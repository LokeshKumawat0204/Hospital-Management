-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 25, 2024 at 07:38 PM
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
-- Database: `hms`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `Aptid` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `slot` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `dept` varchar(50) NOT NULL,
  `number` varchar(50) NOT NULL,
  `doctor` varchar(50) NOT NULL,
  `descrip` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`Aptid`, `name`, `email`, `gender`, `slot`, `date`, `dept`, `number`, `doctor`, `descrip`) VALUES
(20, 'Patient11', 'patient11@gmail.com', 'Male', 'Evening', '2024-04-25', 'Cardiology', '999123456', 'Dr. Farhan', 'Low BP '),
(21, 'Patient12', '123@gmail.com', 'Male', 'Evening', '2024-05-09', 'Cardiology', '999123456', 'Dr. Farhan', 'Heart Pain'),
(23, 'Patient12', '123@gmail.com', 'Female', 'Morning', '2024-05-11', 'Gynaecology', '123456', 'Dr. Sonakshi', 'Low BP '),
(24, 'Patient12', 'patient9@gmail.com', 'Male', 'Evening', '2024-05-04', 'Opthalmology', '999123456', 'Dr. Mahesh', 'Headache'),
(25, 'Patient13', 'patient13@gmail.com', 'Female', 'Night', '2024-05-04', 'Opthalmology', '999123456', 'Dr. Bhatt', 'Hypermetropia'),
(27, 'Patient15', 'patient15@gmail.com', 'Male', 'Morning', '2024-05-05', 'Opthalmology', '999123456', 'Dr. John', 'Low BP '),
(28, 'Patient16', 'patient16@gmail.com', 'Male', 'Morning', '2024-05-04', 'Opthalmology', '999123456', 'Dr. John', 'Myopia'),
(29, 'Patient17', 'patient17@gmail.com', 'Male', 'Morning', '2024-04-12', 'Cardiology', '999123456', 'Dr. Sidhu', 'Headache'),
(30, 'Patient17', 'patient9@gmail.com', 'Male', 'Morning', '2024-04-05', 'Cardiology', '123456', 'Dr. Sidhu', 'Myopia'),
(35, 'Patient9', 'harsh@gmail.com', 'Male', 'Morning', '2024-05-11', 'Cardiology', '9876543210', 'Dr. Sidhu', 'Headache'),
(37, 'Patient9', 'harsh@gmail.com', 'Male', 'Morning', '2024-04-06', 'Gynaecology', '9876543210', 'Dr. Sonakshi', 'Heart Pain'),
(38, 'Patient9', '123@gmail.com', 'Female', 'Evening', '2024-04-25', 'Cardiology', '9876543210', 'Dr. Farhan', 'Low BP '),
(40, 'Patient9', 'admin@gmail.com', 'Male', 'Morning', '2024-05-11', 'Neurology', '9000000000', 'Dr. Aditya', 'Headache'),
(50, 'Patient12', 'patient91@gmail.com', 'Male', 'Morning', '2024-04-30', 'Cardiology', '9876543210', 'Dr. Sidhu', 'Headache'),
(51, 'Nikhil', 'nikhil@gmail.com', 'Male', 'Morning', '2024-05-01', 'Cardiology', '9000000000', 'Dr. Veeru', 'Headache');

--
-- Triggers `booking`
--
DELIMITER $$
CREATE TRIGGER `BookingInsertion` AFTER INSERT ON `booking` FOR EACH ROW INSERT INTO log VALUES(null, NEW.Aptid, NEW.name, NEW.email, NOW(), "Appointment Booked")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `CancelBooking` AFTER DELETE ON `booking` FOR EACH ROW INSERT INTO log VALUES(null, OLD.Aptid, OLD.name, OLD.email, NOW(), "Booking Cancelled")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `did` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `dept` varchar(100) NOT NULL,
  `slot` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`did`, `email`, `name`, `dept`, `slot`) VALUES
(1, 'sidhu@gmail.com', 'Dr. Sidhu', 'Cardiology', 'Morning'),
(2, 'bhattdr@gmail.com', 'Dr. Bhatt', 'Opthalmology', 'Night'),
(3, 'aditya@gmail.com', 'Dr. Aditya', 'Neurology', 'Morning'),
(4, 'sonakshi@gmail.com', 'Dr. Sonakshi', 'Gynaecology', 'Morning'),
(8, 'anil@gmail.com', 'Dr. Anil', 'Neurology', 'Evening'),
(10, 'farhan@gmail.com', 'Dr. Farhan', 'Cardiology', 'Evening'),
(11, 'hritik@gmail.com', 'Dr. Hritik', 'Cardiology', 'Night'),
(12, 'john@gmail.com', 'Dr. John', 'Opthalmology', 'Morning'),
(13, 'mahesh@gmail.com', 'Dr. Mahesh', 'Opthalmology', 'Evening'),
(15, 'vinita@gmail.com', 'Dr. Vinita', 'Gynaecology', 'Night');

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL,
  `did` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `holidays`
--

INSERT INTO `holidays` (`id`, `did`, `date`) VALUES
(1, 1, '2024-04-30'),
(2, 1, '2024-04-26'),
(5, 2, '2024-04-26');

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `id` int(11) NOT NULL,
  `Aptid` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`id`, `Aptid`, `name`, `email`, `time`, `operation`) VALUES
(1, 37, 'Patient9', 'harsh@gmail.com', '2024-04-23 21:33:52', 'Appointment Booked'),
(2, 36, 'Patient10', 'harsh@gmail.com', '2024-04-23 21:34:13', 'Booking Cancelled'),
(3, 38, 'Patient9', '123@gmail.com', '2024-04-23 22:09:09', 'Appointment Booked'),
(4, 39, 'Patient12', 'patient9@gmail.com', '2024-04-23 22:09:48', 'Appointment Booked'),
(5, 39, 'Patient12', 'patient9@gmail.com', '2024-04-23 22:10:43', 'Booking Cancelled'),
(6, 40, 'Patient9', 'admin@gmail.com', '2024-04-24 12:32:57', 'Appointment Booked'),
(7, 22, 'Patient12', '123@gmail.com', '2024-04-24 12:46:18', 'Booking Cancelled'),
(8, 41, 'Patient9', 'test@gmail.com', '2024-04-24 13:12:47', 'Appointment Booked'),
(9, 41, 'Patient9', 'test@gmail.com', '2024-04-24 13:14:11', 'Booking Cancelled'),
(10, 42, 'Patient12', '123@gmail.com', '2024-04-24 13:14:31', 'Appointment Booked'),
(11, 42, 'Patient12', '123@gmail.com', '2024-04-24 13:15:16', 'Booking Cancelled'),
(12, 43, 'Patient12', 'test@gmail.com', '2024-04-24 13:15:30', 'Appointment Booked'),
(13, 43, 'Patient12', 'test@gmail.com', '2024-04-24 13:15:49', 'Booking Cancelled'),
(14, 44, 'Patient9', 'test@gmail.com', '2024-04-24 13:16:05', 'Appointment Booked'),
(15, 45, 'Patient9', 'test@gmail.com', '2024-04-24 13:20:36', 'Appointment Booked'),
(16, 45, 'Patient9', 'test@gmail.com', '2024-04-24 17:31:31', 'Booking Cancelled'),
(17, 44, 'Patient9', 'test@gmail.com', '2024-04-24 17:31:36', 'Booking Cancelled'),
(18, 46, 'Patient12', 'patient22@gmail.com', '2024-04-24 17:43:58', 'Appointment Booked'),
(19, 46, 'Patient12', 'patient22@gmail.com', '2024-04-24 17:44:54', 'Booking Cancelled'),
(20, 47, 'Patient9', 'patient91@gmail.com', '2024-04-24 17:45:15', 'Appointment Booked'),
(21, 47, 'Patient9', 'patient91@gmail.com', '2024-04-24 17:46:36', 'Booking Cancelled'),
(22, 48, 'Patient12', 'patient91@gmail.com', '2024-04-24 17:46:57', 'Appointment Booked'),
(23, 49, 'Patient9', 'patient29@gmail.com', '2024-04-24 17:47:43', 'Appointment Booked'),
(24, 49, 'Patient9', 'patient29@gmail.com', '2024-04-24 17:48:22', 'Booking Cancelled'),
(25, 48, 'Patient12', 'patient91@gmail.com', '2024-04-24 17:48:24', 'Booking Cancelled'),
(26, 50, 'Patient12', 'patient91@gmail.com', '2024-04-24 17:49:08', 'Appointment Booked'),
(27, 51, 'Nikhil', 'nikhil@gmail.com', '2024-04-25 14:08:16', 'Appointment Booked');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'patient',
  `password` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `role`, `password`) VALUES
(1, 'test1', 'test1@gmail.com', 'patient', 'scrypt:32768:8:1$vVAU8mNhLLKcWL9g$0cb6c90dcefca95fa90266c5cd09e4e7f0fe99487aa6253e215bf6c7c2e96fdf7ab55795b77af0b59cd0a041e85a900755a968e56b3650ff2655f96bcdc9ea6e'),
(2, 'test', 'test@gmail.com', 'patient', 'scrypt:32768:8:1$apNRHV6fPiZGlCS0$955073855dcaa467fb65a899567c4ee337167d601167fa0ab2e2c18b8518cbdd1bae905bca84ad68864b79dd6e8a78e9a87554f61170c2c6b268cacfacf53842'),
(3, 'gaurav', 'gaurav@gmail.com', 'patient', 'scrypt:32768:8:1$eGoxFmtAT2o42HCm$2ea6b30c7deafda3786f3a1e9e8ef76e747fa186a73748d79d29962f463cff543933d3520eb20948f2dc221d2b1daddfb3ad38748e6295d710d14b11e2587a4c'),
(4, '123', '123@gmail.com', 'patient', 'scrypt:32768:8:1$AEG0T0gid19bbieZ$59c80383f1c9bc7767f03741615c54df68038217f6acac4b6c13c5fa3630ac98847a9f6818986f27b2c2248d0a7c315f898fc0639da7575ab526c40e2788dea6'),
(5, 'Harsh', 'harsh@gmail.com', 'patient', 'scrypt:32768:8:1$xLKVBbMhJcShGYBm$3419089ea2cdc88e2c5322ad8d16e5d14237c7760e3a67e9074de155e78d523df192bccf45a621477006702efdff54d62dda54e89d4d3e2b9909fecded02f817'),
(6, 'admin', 'admin@gmail.com', 'admin', 'admin@123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`Aptid`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`did`),
  ADD UNIQUE KEY `unique_slot_department` (`slot`,`dept`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `did` (`did`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `Aptid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `did` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `holidays`
--
ALTER TABLE `holidays`
  ADD CONSTRAINT `holidays_ibfk_1` FOREIGN KEY (`did`) REFERENCES `doctors` (`did`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
