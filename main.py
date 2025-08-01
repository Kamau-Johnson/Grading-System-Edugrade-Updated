from flask import Flask, render_template, request, jsonify, redirect, url_for, flash, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from functools import wraps
from datetime import datetime
import json
import traceback

app = Flask(__name__)
app.secret_key = 'your_secret_key_here_make_it_secure'

DB_CONFIG = {
    "host": "localhost",
    "port": 3307,
    "user": "root",
    "password": "",
    "database": "edugradedb"
}

def get_db_connection():
    try: 
        return mysql.connector.connect(**DB_CONFIG)
    except mysql.connector.Error as e:
        print(f"Database connection error: {e}")
        return None

def execute_query(query, params=None, fetch=False):
    connection = get_db_connection()
    if not connection: 
        return None if fetch else False
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        if fetch: 
            result = cursor.fetchall()
        else: 
            connection.commit()
            result = True
        return result
    except mysql.connector.Error as e:
        if connection:
            connection.rollback()
        raise e # Re-raise the error so the calling function can catch it

    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()

def teacher_login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'role' not in session or session.get('role') != 'teacher':
            flash('Please log in to access this page.', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/')
def index(): 
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        access_code = request.form.get('access_code')
        password = request.form.get('password')
        try:
            # Query adapted for your login table structure
            query = "SELECT * FROM login WHERE username=%s AND role='teacher'"
            user_data = execute_query(query, (access_code,), fetch=True)
            if user_data and check_password_hash(user_data[0]['password'], password):
                user = user_data[0]
                session.clear()
                session['user_id'] = user['loginID']
                session['username'] = user['username']
                session['teachID'] = user['teachID']
                session['role'] = 'teacher'
                return redirect(url_for('dashboard'))
            else:
                flash('Invalid credentials. Please try again.', 'error')
        except mysql.connector.Error as e:
            flash(f"Database error: {e}", "error")
    return render_template('login.html')

@app.route('/users_signup', methods=['GET', 'POST'])
def user_signup():
    if request.method == 'POST':
        access_code = request.form['access_code']
        password = request.form['password']
        if password != request.form['confirm_password']:
            flash('Passwords do not match.', 'error')
            return redirect(url_for('user_signup'))
        
        connection = get_db_connection()
        if not connection:
            flash("Database connection is not available.", "error")
            return redirect(url_for('user_signup'))
            
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT 1 FROM login WHERE username = %s", (access_code,))
            if cursor.fetchone():
                flash('This Access Code is already taken.', 'error')
                return redirect(url_for('user_signup'))

            teacher_query = "INSERT INTO teachers (teachname, email, gender, class, phonenumber) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(teacher_query, (f"Teacher {access_code}", f"{access_code}@school.com", 'Not Specified', 'Unassigned', '0000000000'))
            new_teach_id = cursor.lastrowid
            
            hashed_password = generate_password_hash(password)
            # Query adapted for your login table structure
            login_query = "INSERT INTO login (username, password, role, teachID) VALUES (%s, %s, 'teacher', %s)"
            cursor.execute(login_query, (access_code, hashed_password, new_teach_id))
            
            connection.commit()
            flash('Teacher account created successfully! Please log in.', 'success')
            return redirect(url_for('login'))
        except mysql.connector.Error as e:
            if connection: 
                connection.rollback()
            flash(f"Database error: {e}", "error")
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()
    return render_template('sign_up.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))

@app.route('/dashboard')
@teacher_login_required
def dashboard():
    try:
        teacher_data = execute_query("SELECT teachname FROM teachers WHERE teachID = %s", (session['teachID'],), fetch=True)
        teacher_name = teacher_data[0]['teachname'] if teacher_data else "Teacher"
        
        total_students_query = "SELECT COUNT(*) as count FROM students WHERE teachID = %s"
        total_students_result = execute_query(total_students_query, (session['teachID'],), fetch=True)
        total_students = total_students_result[0]['count'] if total_students_result else 0
        
        return render_template('teachers_dashboard.html', teacher_name=teacher_name, total_students=total_students)
    except mysql.connector.Error as e:
        flash(f"Could not load dashboard data. DB Error: {e}", "error")
        return render_template('teachers_dashboard.html', teacher_name="Teacher", total_students=0)

@app.route('/api/dashboard_data')
@teacher_login_required
def dashboard_data():
    try:
        total_students_query = "SELECT COUNT(*) as count FROM students WHERE teachID = %s"
        total_students_result = execute_query(total_students_query, (session['teachID'],), fetch=True)
        total_students = total_students_result[0]['count'] if total_students_result else 0
        return jsonify({'success': True, 'total_students': total_students})
    except mysql.connector.Error as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/get_students')
@teacher_login_required
def get_students():
    try:
        query = "SELECT studID, studname, admno, gender, class FROM students WHERE teachID = %s ORDER BY studname"
        students = execute_query(query, (session['teachID'],), fetch=True)
        return jsonify({'success': True, 'students': students or []})
    except mysql.connector.Error as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/add_student', methods=['POST'])
@teacher_login_required
def add_student():
    data = request.json
    try:
        query = "INSERT INTO students (studname, admno, gender, dob, class, teachID) VALUES (%s, %s, %s, %s, %s, %s)"
        params = (data['studname'], data['admno'], data['gender'], data['dob'], data['class'], session['teachID'])
        execute_query(query, params)
        return jsonify({'success': True, 'message': 'Student added successfully!'})
    except mysql.connector.Error as e:
        if e.errno == 1062:
            return jsonify({'success': False, 'message': f"Error: Admission Number '{data['admno']}' already exists."})
        return jsonify({'success': False, 'message': 'A database error occurred.'})

@app.route('/api/delete_student/<int:stud_id>', methods=['DELETE'])
@teacher_login_required
def delete_student(stud_id):
    try:
        execute_query("DELETE FROM marks WHERE studID = %s", (stud_id,))
        success = execute_query("DELETE FROM students WHERE studID = %s AND teachID = %s", (stud_id, session['teachID']))
        return jsonify({'success': success, 'message': 'Student and their marks deleted.' if success else 'Error deleting student.'})
    except mysql.connector.Error as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/get_marks_list')
@teacher_login_required
def get_marks_list():
    try:
        query = """
            SELECT s.studID, s.studname, s.admno, s.class, m.meanscore, m.remark 
            FROM students s 
            LEFT JOIN marks m ON s.studID = m.studID
            WHERE s.teachID = %s
            GROUP BY s.studID, s.studname, s.admno, s.class
            ORDER BY s.studname
        """
        marks = execute_query(query, (session['teachID'],), fetch=True)
        return jsonify({'success': True, 'marks': marks or []})
    except mysql.connector.Error as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/get_detailed_marks/<int:stud_id>')
@teacher_login_required
def get_detailed_marks(stud_id):
    # This function cannot get detailed marks because your `marks` table does not store them.
    # We will return success: False so the UI shows an empty form.
    return jsonify({'success': False, 'message': 'Detailed marks not available in this database schema.'})

@app.route('/api/save_detailed_marks', methods=['POST'])
@teacher_login_required
def save_detailed_marks():
    try:
        data = request.json
        
        # Get student name from database, as it's required by your `marks` table
        student_info = execute_query("SELECT studname FROM students WHERE studID = %s", (data['studID'],), fetch=True)
        if not student_info:
            return jsonify({'success': False, 'message': 'Student not found.'})
        studname = student_info[0]['studname']
        
        # Prepare data for your specific `marks` table
        ovrscore = int(float(data.get('ovrscore', 0)))
        meanscore = int(float(data.get('meanscore', 0)))
        remark = data.get('remark', '')
        # The 'marks' column is ambiguous, so we'll use the mean score
        marks_value = meanscore 

        # Check if a record already exists for this student
        existing_mark = execute_query("SELECT markID FROM marks WHERE studID = %s", (data['studID'],), fetch=True)
        
        if existing_mark:
            # UPDATE existing record
            query = """
                UPDATE marks SET marks=%s, studname=%s, ovrscore=%s, meanscore=%s, remark=%s 
                WHERE studID=%s
            """
            params = (marks_value, studname, ovrscore, meanscore, remark, data['studID'])
        else:
            # INSERT new record
            query = """
                INSERT INTO marks (marks, studID, studname, ovrscore, meanscore, remark) 
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            params = (marks_value, data['studID'], studname, ovrscore, meanscore, remark)

        execute_query(query, params)
        return jsonify({'success': True, 'message': 'Marks saved successfully!'})

    except mysql.connector.Error as e:
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'})
    except Exception as e:
        traceback.print_exc()
        return jsonify({'success': False, 'message': f'Server error: {str(e)}'})

@app.route('/api/generate_detailed_report')
@teacher_login_required
def generate_detailed_report():
    try:
        stud_id = request.args.get('studID')
        
        # Query adapted to your database schema
        query = """
            SELECT s.studname, s.admno, s.class, m.ovrscore, m.meanscore, m.remark
            FROM students s 
            JOIN marks m ON s.studID = m.studID 
            WHERE s.studID = %s AND s.teachID = %s
        """
        
        data = execute_query(query, (stud_id, session['teachID']), fetch=True)
        
        if data:
            report_data = data[0]
            # Since there are no detailed marks, we create an empty 'subjects' object
            # so the HTML template doesn't crash.
            report_data['subjects'] = {}
            report_data['term'] = "N/A" # Your marks table doesn't have a term
            return jsonify({'success': True, 'data': report_data})
        else:
            return jsonify({'success': False, 'message': 'No report data found for this student.'})
            
    except Exception as e:
        return jsonify({'success': False, 'message': f'Server error: {str(e)}'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)