-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Aug 01, 2025 at 08:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `edugradedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `classID` int(11) NOT NULL,
  `classname` varchar(100) NOT NULL,
  `teachname` varchar(255) NOT NULL,
  `teachID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`classID`, `classname`, `teachname`, `teachID`) VALUES
(1, 'grade 1A', 'Mary Johnson', 1),
(2, 'grade 1B', 'James Wilson', 2),
(3, 'grade 2A', 'Lisa Anderson', 3),
(4, 'grade 2B', 'Robert Taylor', 4),
(5, 'grade 3A', 'Patricia Moore', 5),
(6, 'grade 3B', 'Thomas Clark', 6),
(7, 'grade 4A', 'Jennifer White', 7),
(8, 'grade 4B', 'Kevin Miller', 8),
(9, 'grade 5A', 'Amanda Davis', 9),
(10, 'grade 5B', 'Steven Johnson', 10);

-- --------------------------------------------------------

--
-- Stand-in structure for view `femalestudents`
-- (See below for the actual view)
--
CREATE TABLE `femalestudents` (
`studID` int(11)
,`admno` varchar(50)
,`studname` varchar(255)
,`gender` varchar(255)
,`dob` date
,`class` text
,`teachID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `femaleteachers`
-- (See below for the actual view)
--
CREATE TABLE `femaleteachers` (
`teachID` int(11)
,`teachname` varchar(255)
,`email` varchar(50)
,`phonenumber` varchar(20)
,`gender` varchar(255)
,`class` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `grade1ateachers`
-- (See below for the actual view)
--
CREATE TABLE `grade1ateachers` (
`teachID` int(11)
,`teachname` varchar(255)
,`email` varchar(50)
,`phonenumber` varchar(20)
,`gender` varchar(255)
,`class` text
);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `loginID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','teacher') NOT NULL,
  `studID` int(11) DEFAULT NULL,
  `teachID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`loginID`, `username`, `password`, `role`, `studID`, `teachID`) VALUES
(6, 'TCH001', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 1),
(7, 'TCH002', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 2),
(8, 'TCH003', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 3),
(9, 'TCH004', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 4),
(10, 'TCH005', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 5),
(11, 'TCH006', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 6),
(12, 'TCH007', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 7),
(13, 'TCH008', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 8),
(14, 'TCH009', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 9),
(15, 'TCH010', 'pbkdf2:sha256:600000$Z7L0dYnJtWkR1vHh$d23c1045a90e3f84750c1837c1524e93096d27453d86b9b32c1b74a441de2fad', 'teacher', NULL, 10),
(16, '87', 'scrypt:32768:8:1$Y5D9UkkYjVT3xOfb$01923c28c1ef2dc76d3cb90c70592a11c9dc2d414882ddb734d484dddd31680867b478471f940ba3d94086086c722e83e4638f1493e940f8db3adc5eb8cab630', 'teacher', NULL, 11);

-- --------------------------------------------------------

--
-- Stand-in structure for view `malestudents`
-- (See below for the actual view)
--
CREATE TABLE `malestudents` (
`studID` int(11)
,`admno` varchar(50)
,`studname` varchar(255)
,`gender` varchar(255)
,`dob` date
,`class` text
,`teachID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `maleteachers`
-- (See below for the actual view)
--
CREATE TABLE `maleteachers` (
`teachID` int(11)
,`teachname` varchar(255)
,`email` varchar(50)
,`phonenumber` varchar(20)
,`gender` varchar(255)
,`class` text
);

-- --------------------------------------------------------

--
-- Table structure for table `marks`
--

CREATE TABLE `marks` (
  `markID` int(11) NOT NULL,
  `marks` int(11) NOT NULL,
  `studID` int(11) NOT NULL,
  `studname` varchar(255) NOT NULL,
  `ovrscore` int(11) NOT NULL,
  `meanscore` int(11) NOT NULL,
  `remark` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `marks`
--

INSERT INTO `marks` (`markID`, `marks`, `studID`, `studname`, `ovrscore`, `meanscore`, `remark`) VALUES
(1, 85, 1, 'John Otieno', 425, 85, 'Excellent performance'),
(2, 78, 2, 'Sarah Johnson', 390, 78, 'Good performance'),
(3, 92, 3, 'Michael Brown', 460, 92, 'Outstanding performance'),
(4, 75, 4, 'Emily Moraa', 375, 75, 'Satisfactory performance'),
(5, 88, 5, 'David Mutua', 440, 88, 'Very good performance'),
(6, 81, 6, 'Emma Thompson', 405, 81, 'Good performance'),
(7, 95, 7, 'Christopher Martin', 475, 95, 'Exceptional performance'),
(8, 72, 8, 'Sophia Rodriguez', 360, 72, 'Average performance'),
(9, 87, 9, 'Daniel kamau', 435, 87, 'Very good performance'),
(10, 83, 10, 'Olivia Naliaka', 415, 83, 'Good performance'),
(11, 84, 11, 'Johnson Kamau', 139, 84, 'love you');

-- --------------------------------------------------------

--
-- Stand-in structure for view `studentperformance`
-- (See below for the actual view)
--
CREATE TABLE `studentperformance` (
`studID` int(11)
,`studname` varchar(255)
,`class` text
,`marks` int(11)
,`ovrscore` int(11)
,`meanscore` int(11)
,`remark` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `studentperformancefiltered`
-- (See below for the actual view)
--
CREATE TABLE `studentperformancefiltered` (
`studID` int(11)
,`studname` varchar(255)
,`class` text
,`marks` int(11)
,`ovrscore` int(11)
,`meanscore` int(11)
,`remark` text
);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `studID` int(11) NOT NULL,
  `admno` varchar(50) NOT NULL,
  `studname` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `dob` date NOT NULL,
  `class` text NOT NULL,
  `teachID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`studID`, `admno`, `studname`, `gender`, `dob`, `class`, `teachID`) VALUES
(1, '1001', 'John Otieno', 'Male', '2005-03-15', 'grade 1A', 1),
(2, '1002', 'Sarah Johnson', 'Female', '2005-07-22', 'grade 1A', 1),
(3, '1003', 'Michael Brown', 'Male', '2005-01-10', 'grade 1B', 2),
(4, '1004', 'Emily Moraa', 'Female', '2005-11-05', 'grade 1B', 2),
(5, '1005', 'David Mutua', 'Male', '2005-09-18', 'grade 2A', 3),
(6, '1006', 'Emma Thompson', 'Female', '2005-04-12', 'grade 2A', 3),
(7, '1007', 'Christopher Martin', 'Male', '2005-08-30', 'grade 2B', 4),
(8, '1008', 'Sophia Rodriguez', 'Female', '2005-12-03', 'grade 3A', 5),
(9, '1009', 'Daniel kamau', 'Male', '2005-06-25', 'grade 3B', 6),
(10, '1010', 'Olivia Naliaka', 'Female', '2005-02-14', 'grade 4A', 7),
(11, '3', 'Johnson Kamau', 'Male', '2005-11-11', 'grade 4A', 11);

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `subcode` int(11) NOT NULL,
  `subname` varchar(50) NOT NULL,
  `teachname` varchar(255) NOT NULL,
  `teachID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`subcode`, `subname`, `teachname`, `teachID`) VALUES
(101, 'Mathematics', 'Mary Johnson', 1),
(102, 'English', 'James Wilson', 2),
(103, 'Kiswahili', 'Lisa Anderson', 3),
(104, 'Environmental Activities', 'Robert Taylor', 4),
(105, 'Creative Arts', 'Patricia Moore', 5),
(106, 'Physical Education', 'Thomas Clark', 6),
(107, 'Religious Education', 'Jennifer White', 7),
(108, 'Social Studies', 'Kevin Miller', 8),
(109, 'Science and Technology', 'Amanda Davis', 9),
(110, 'Life Skills', 'Steven Johnson', 10);

-- --------------------------------------------------------

--
-- Stand-in structure for view `teachercontacts`
-- (See below for the actual view)
--
CREATE TABLE `teachercontacts` (
`teachname` varchar(255)
,`email` varchar(50)
,`phonenumber` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teachID` int(11) NOT NULL,
  `teachname` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phonenumber` varchar(20) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `class` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`teachID`, `teachname`, `email`, `phonenumber`, `gender`, `class`) VALUES
(1, 'Mary Johnson', 'mary.johnson@school.com', '123456789', 'Female', 'grade 1A'),
(2, 'James Wilson', 'james.wilson@school.com', '987654321', 'Male', 'grade 1B'),
(3, 'Lisa Anderson', 'lisa.anderson@school.com', '555123456', 'Female', 'grade 2A'),
(4, 'Robert Taylor', 'robert.taylor@school.com', '777888999', 'Male', 'grade 2B'),
(5, 'Patricia Moore', 'patricia.moore@school.com', '444555666', 'Female', 'grade 3A'),
(6, 'Thomas Clark', 'thomas.clark@school.com', '111222333', 'Male', 'grade 3B'),
(7, 'Jennifer White', 'jennifer.white@school.com', '222333444', 'Female', 'grade 4A'),
(8, 'Kevin Miller', 'kevin.miller@school.com', '333444555', 'Male', 'grade 4B'),
(9, 'Amanda Davis', 'amanda.davis@school.com', '444555666', 'Female', 'grade 5A'),
(10, 'Steven Johnson', 'steven.johnson@school.com', '555666777', 'Male', 'grade 5B'),
(11, 'Teacher 87', '87@school.com', '0000000000', 'Not Specified', 'Unassigned');

-- --------------------------------------------------------

--
-- Structure for view `femalestudents`
--
DROP TABLE IF EXISTS `femalestudents`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `femalestudents`  AS SELECT `students`.`studID` AS `studID`, `students`.`admno` AS `admno`, `students`.`studname` AS `studname`, `students`.`gender` AS `gender`, `students`.`dob` AS `dob`, `students`.`class` AS `class`, `students`.`teachID` AS `teachID` FROM `students` WHERE `students`.`gender` = 'Female' ;

-- --------------------------------------------------------

--
-- Structure for view `femaleteachers`
--
DROP TABLE IF EXISTS `femaleteachers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `femaleteachers`  AS SELECT `teachers`.`teachID` AS `teachID`, `teachers`.`teachname` AS `teachname`, `teachers`.`email` AS `email`, `teachers`.`phonenumber` AS `phonenumber`, `teachers`.`gender` AS `gender`, `teachers`.`class` AS `class` FROM `teachers` WHERE `teachers`.`gender` = 'Female' ;

-- --------------------------------------------------------

--
-- Structure for view `grade1ateachers`
--
DROP TABLE IF EXISTS `grade1ateachers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `grade1ateachers`  AS SELECT `teachers`.`teachID` AS `teachID`, `teachers`.`teachname` AS `teachname`, `teachers`.`email` AS `email`, `teachers`.`phonenumber` AS `phonenumber`, `teachers`.`gender` AS `gender`, `teachers`.`class` AS `class` FROM `teachers` WHERE `teachers`.`class` = 'grade 1A' ;

-- --------------------------------------------------------

--
-- Structure for view `malestudents`
--
DROP TABLE IF EXISTS `malestudents`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `malestudents`  AS SELECT `students`.`studID` AS `studID`, `students`.`admno` AS `admno`, `students`.`studname` AS `studname`, `students`.`gender` AS `gender`, `students`.`dob` AS `dob`, `students`.`class` AS `class`, `students`.`teachID` AS `teachID` FROM `students` WHERE `students`.`gender` = 'male' ;

-- --------------------------------------------------------

--
-- Structure for view `maleteachers`
--
DROP TABLE IF EXISTS `maleteachers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `maleteachers`  AS SELECT `teachers`.`teachID` AS `teachID`, `teachers`.`teachname` AS `teachname`, `teachers`.`email` AS `email`, `teachers`.`phonenumber` AS `phonenumber`, `teachers`.`gender` AS `gender`, `teachers`.`class` AS `class` FROM `teachers` WHERE `teachers`.`gender` = 'Male' ;

-- --------------------------------------------------------

--
-- Structure for view `studentperformance`
--
DROP TABLE IF EXISTS `studentperformance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `studentperformance`  AS SELECT `s`.`studID` AS `studID`, `s`.`studname` AS `studname`, `s`.`class` AS `class`, `m`.`marks` AS `marks`, `m`.`ovrscore` AS `ovrscore`, `m`.`meanscore` AS `meanscore`, `m`.`remark` AS `remark` FROM (`students` `s` join `marks` `m`) WHERE `s`.`studID` = `m`.`studID` ;

-- --------------------------------------------------------

--
-- Structure for view `studentperformancefiltered`
--
DROP TABLE IF EXISTS `studentperformancefiltered`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `studentperformancefiltered`  AS SELECT `s`.`studID` AS `studID`, `s`.`studname` AS `studname`, `s`.`class` AS `class`, `m`.`marks` AS `marks`, `m`.`ovrscore` AS `ovrscore`, `m`.`meanscore` AS `meanscore`, `m`.`remark` AS `remark` FROM (`students` `s` join `marks` `m`) WHERE `s`.`studID` = `m`.`studID` AND `m`.`marks` > 80 ;

-- --------------------------------------------------------

--
-- Structure for view `teachercontacts`
--
DROP TABLE IF EXISTS `teachercontacts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `teachercontacts`  AS SELECT `teachers`.`teachname` AS `teachname`, `teachers`.`email` AS `email`, `teachers`.`phonenumber` AS `phonenumber` FROM `teachers` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`classID`),
  ADD KEY `teachID` (`teachID`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`loginID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `studID` (`studID`),
  ADD KEY `teachID` (`teachID`);

--
-- Indexes for table `marks`
--
ALTER TABLE `marks`
  ADD PRIMARY KEY (`markID`),
  ADD KEY `studID` (`studID`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`studID`),
  ADD UNIQUE KEY `admno` (`admno`),
  ADD KEY `teachID` (`teachID`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`subcode`),
  ADD KEY `teachID` (`teachID`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teachID`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `classID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `loginID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `marks`
--
ALTER TABLE `marks`
  MODIFY `markID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `studID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teachID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`teachID`) REFERENCES `teachers` (`teachID`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`studID`) REFERENCES `students` (`studID`),
  ADD CONSTRAINT `login_ibfk_2` FOREIGN KEY (`teachID`) REFERENCES `teachers` (`teachID`);

--
-- Constraints for table `marks`
--
ALTER TABLE `marks`
  ADD CONSTRAINT `marks_ibfk_1` FOREIGN KEY (`studID`) REFERENCES `students` (`studID`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`teachID`) REFERENCES `teachers` (`teachID`) ON DELETE SET NULL;

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`teachID`) REFERENCES `teachers` (`teachID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
