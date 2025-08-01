# THIS IS THE COMPROMISE db_setup.py
# It uses your team's schema but is adapted to work with the Python app.

import mysql.connector
from mysql.connector import Error

DB_CONFIG = { 
    "host": "localhost", 
    "port": 3307, 
    "user": "root", 
    "password": "" 
}
DB_NAME = "edugradedb"

def run_query(cursor, query, message):
    try:
        # Some versions of connector require consuming results from multi-queries
        for _ in cursor.execute(query, multi=True): 
            pass
        print(f"-> SUCCESS: {message}")
    except Error as e:
        print(f"-> FAILED: {message} | Error: {e}")

def setup_database():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()
        
        print(f"Creating database '{DB_NAME}' if it does not exist...")
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
        cursor.execute(f"USE {DB_NAME}")
        print("-> Success: Database is ready.\n")

        # Drop tables in reverse order of dependency to ensure a clean slate
        print("--- DROPPING EXISTING TABLES FOR A CLEAN SETUP ---")
        run_query(cursor, "DROP TABLE IF EXISTS marks;", "Dropping `marks`")
        run_query(cursor, "DROP TABLE IF EXISTS login;", "Dropping `login`")
        run_query(cursor, "DROP TABLE IF EXISTS subjects;", "Dropping `subjects`")
        run_query(cursor, "DROP TABLE IF EXISTS students;", "Dropping `students`")
        run_query(cursor, "DROP TABLE IF EXISTS classes;", "Dropping `classes`")
        run_query(cursor, "DROP TABLE IF EXISTS teachers;", "Dropping `teachers`")
        # The 'reports' table is not needed by the application, so we don't create it.
        run_query(cursor, "DROP TABLE IF EXISTS reports;", "Dropping unused `reports` table")
        print("")


        print("--- CREATING TABLES WITH COMPATIBLE SCHEMA ---")
        
        tables = {
            'teachers': """
                CREATE TABLE IF NOT EXISTS teachers (
                    teachID INT PRIMARY KEY AUTO_INCREMENT, 
                    teachname VARCHAR(255) NOT NULL,
                    email VARCHAR(100) NOT NULL UNIQUE, 
                    phonenumber VARCHAR(20),
                    gender VARCHAR(50) NOT NULL, 
                    class TEXT NOT NULL
                ) ENGINE=InnoDB; 
            """,
            'students': """
                CREATE TABLE IF NOT EXISTS students (
                    studID INT PRIMARY KEY AUTO_INCREMENT, 
                    admno VARCHAR(50) NOT NULL UNIQUE,
                    studname VARCHAR(255) NOT NULL, 
                    gender VARCHAR(50) NOT NULL,
                    dob DATE NOT NULL, 
                    class VARCHAR(100) NOT NULL,
                    teachID INT, 
                    FOREIGN KEY (teachID) REFERENCES teachers(teachID) ON DELETE SET NULL
                ) ENGINE=InnoDB; 
            """,
            'classes': """
                CREATE TABLE IF NOT EXISTS classes (
                    classID INT PRIMARY KEY AUTO_INCREMENT,
                    classname VARCHAR(100) NOT NULL
                ) ENGINE=InnoDB; 
            """,
            'subjects': """
                CREATE TABLE IF NOT EXISTS subjects (
                    subjectID INT PRIMARY KEY AUTO_INCREMENT,
                    subjectname VARCHAR(100) NOT NULL,
                    teachername VARCHAR(255),
                    subcode INT UNIQUE
                ) ENGINE=InnoDB;
            """,
            'login': """
                CREATE TABLE IF NOT EXISTS login (
                    loginID INT PRIMARY KEY AUTO_INCREMENT, 
                    username VARCHAR(50) NOT NULL UNIQUE,
                    password VARCHAR(255) NOT NULL, 
                    teachID INT,
                    FOREIGN KEY (teachID) REFERENCES teachers(teachID) ON DELETE CASCADE
                ) ENGINE=InnoDB; 
            """,
            'marks': """
                CREATE TABLE IF NOT EXISTS marks (
                    markID INT PRIMARY KEY AUTO_INCREMENT,
                    studID INT NOT NULL, 
                    ovrscore DECIMAL(5,2), 
                    meanscore DECIMAL(5,2), 
                    remark TEXT,
                    term VARCHAR(20) NOT NULL, 
                    year YEAR NOT NULL,
                    marks_details JSON, 
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    FOREIGN KEY (studID) REFERENCES students(studID) ON DELETE CASCADE,
                    UNIQUE KEY student_term_year_unique (studID, term, year)
                ) ENGINE=InnoDB; 
            """
        }
        
        for name, query in tables.items():
            run_query(cursor, query, f"Creating table '{name}'")
        
        connection.commit()
        cursor.close()
        connection.close()
        print("\n Database setup completed successfully with a compatible structure!")
        
    except Error as e:
        print(f" DATABASE ERROR: {e}")

if __name__ == "__main__":
    setup_database()