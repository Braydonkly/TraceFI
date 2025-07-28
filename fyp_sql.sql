-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 28, 2025 at 06:21 AM
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
-- Database: `fyp_sql`
--

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `FI_id` int(11) DEFAULT NULL,
  `client_name` varchar(45) DEFAULT NULL,
  `client_NRIC` varchar(45) DEFAULT NULL,
  `client_nationality` varchar(45) DEFAULT NULL,
  `customer_type` varchar(100) DEFAULT NULL,
  `client_citizenship` varchar(45) DEFAULT NULL,
  `client_address` varchar(45) DEFAULT NULL,
  `client_postalcode` varchar(45) DEFAULT NULL,
  `client_gender` varchar(45) DEFAULT NULL,
  `client_cob` varchar(45) DEFAULT NULL,
  `client_dob` varchar(45) DEFAULT NULL,
  `client_home_number` varchar(45) DEFAULT NULL,
  `client_phone_number` varchar(45) DEFAULT NULL,
  `client_occupation` varchar(45) DEFAULT NULL,
  `pep_status` varchar(100) DEFAULT NULL,
  `source_of_funds` varchar(100) DEFAULT NULL,
  `client_employer_name` varchar(45) DEFAULT NULL,
  `client_employer_number` varchar(45) DEFAULT NULL,
  `risk_status` enum('N/A','Low','Medium','High','Blocked') NOT NULL DEFAULT 'N/A',
  `image` varchar(255) DEFAULT NULL,
  `geography_score` int(11) DEFAULT 0,
  `customer_type_score` int(11) DEFAULT 0,
  `occupation_score` int(11) DEFAULT 0,
  `pep_score` int(11) DEFAULT 0,
  `source_of_funds_score` int(11) DEFAULT 0,
  `transaction_behavior_score` int(11) DEFAULT 0,
  `previous_sar_score` int(11) DEFAULT 0,
  `total_risk_score` int(11) DEFAULT 0,
  `is_duplicate` tinyint(1) DEFAULT 0,
  `aml_flag_reason` varchar(255) DEFAULT NULL,
  `warning_flag` tinyint(1) DEFAULT 0,
  `on_blockchain` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `FI_id`, `client_name`, `client_NRIC`, `client_nationality`, `customer_type`, `client_citizenship`, `client_address`, `client_postalcode`, `client_gender`, `client_cob`, `client_dob`, `client_home_number`, `client_phone_number`, `client_occupation`, `pep_status`, `source_of_funds`, `client_employer_name`, `client_employer_number`, `risk_status`, `image`, `geography_score`, `customer_type_score`, `occupation_score`, `pep_score`, `source_of_funds_score`, `transaction_behavior_score`, `previous_sar_score`, `total_risk_score`, `is_duplicate`, `aml_flag_reason`, `warning_flag`, `on_blockchain`) VALUES
(1, 4, 'John Low', 'T0570905H', 'Singapore', 'Anonymous account', 'Singaporean', '123 Orchard Road', '238887', 'Male', 'Singapore', '1990-01-01', '61234567', '91234567', 'Software Engineer', 'Foreign PEP', 'Savings', 'TechCorp Ltd.', '67890123', 'Medium', 'john_low.png', 0, 20, 0, 25, 0, 0, 15, 60, 0, NULL, 0, 0),
(2, 3, 'Jane Smith', 'S1234567D', 'Malaysia', 'Offshore company', 'Singaporean', '456 Bukit Timah Road', '279888', 'Female', 'Malaysia', '1985-05-15', '61239876', '91123456', 'Accountant', NULL, NULL, 'FinancePro Inc.', '65678901', 'Medium', 'jane_smith.jpg', 0, 20, 0, 0, 0, 0, 15, 35, 0, NULL, 0, 0),
(3, 4, 'Benjamin Lee', 'S1234567A', 'Malaysia', 'Individual', 'Singaporean', '123 Orchard Rd, Singapore', '238888', 'Male', 'Malaysia', '1985-04-12', '61234567', '91234567', 'Businessman', 'Foreign PEP', 'Cryptocurrency Proceeds', 'Lee Holdings', '61234567', 'High', NULL, 10, 0, 0, 25, 20, 15, 15, 85, 0, NULL, 0, 0),
(4, 2, 'John Low', 'S3456789C', 'Philippines', 'Individual', 'Singaporean', '789 Clementi Ave, Singapore', '120888', 'Male', 'Philippines', '1992-01-15', '61234569', '91234569', 'Engineer', 'None', 'Salary', 'Low Engineering', '61234569', 'Low', NULL, 10, 0, 0, 0, 0, 15, 15, 40, 0, NULL, 0, 0),
(5, 3, 'Krishna Rao', 'S4567890D', 'India', 'Trust', 'Singaporean', '321 Serangoon Rd, Singapore', '218888', 'Male', 'India', '1978-07-30', '61234570', '91234570', 'Consultant', 'Domestic PEP', 'Cryptocurrency Proceeds', 'Rao Trust', '61234570', 'High', NULL, 10, 20, 0, 25, 20, 15, 15, 105, 0, NULL, 0, 0),
(6, 2, 'Amina Yusuf', 'S5678901E', 'Nigeria', 'Individual', 'Singaporean', '654 Bedok North, Singapore', '460888', 'Female', 'Nigeria', '1988-11-05', '61234571', '91234571', 'Teacher', 'None', 'Salary', 'Bedok School', '61234571', 'Medium', NULL, 20, 0, 0, 0, 0, 15, 15, 50, 0, NULL, 0, 0),
(26, 5, 'Isabella Tan Mei Ling', 'S1234567D', 'Singaporean', 'Individual', 'Singapore', '123 Serangoon Avenue 3, #04-56', '550123', 'Female', 'Singapore', '2025-07-16', '64567890', '91234567', 'Compliance Manager', 'Domestic PEP', 'Cryptocurrency Proceeds', 'Meridian Financial Group', '62233456', 'Blocked', 'isabella.jpg', 0, 0, 0, 25, 20, 15, 15, 75, 1, 'Potential identity misuse: Duplicate NRIC with medium-risk client', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `financial_institute`
--

CREATE TABLE `financial_institute` (
  `FI_id` int(11) NOT NULL,
  `employee_id` varchar(45) NOT NULL,
  `institute_name` varchar(45) DEFAULT NULL,
  `institute_email` varchar(45) DEFAULT NULL,
  `institute_contact_name` varchar(45) DEFAULT NULL,
  `institute_phone_number` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `financial_institute`
--

INSERT INTO `financial_institute` (`FI_id`, `employee_id`, `institute_name`, `institute_email`, `institute_contact_name`, `institute_phone_number`, `password`, `role`) VALUES
(1, 'OCBC-EMP0372', 'OCBC', 'aaron.lee@ocbc.com', 'Aaron Lee', '+65 65381111', '0f451e3475d49a93075134d0436ce4106f31e97e', 'user'),
(2, 'MAS-EMP0154', 'MAS', 'samantha_tan@mas.gov.sg ', 'Samantha Tan', '+65 62255577', '5f8992a5f5df2e39cfdeb44c93f510059a99dc51', 'user'),
(3, 'GLDB-EMP0887', 'GLDB', 'james.ong@glbank.com', 'James Ong', '+65 69928989', 'cb68f3c7c1671a1b8a471313c66ae56ba6751f9f', 'user'),
(4, 'MAYBANK-EMP0421', 'Maybank', 'tkhoo@maybank.com', 'Timothy Khoo', '1800-777 0022', '7f03e84fd0345aa8f1a2af12f9ef6a69507b6e34', 'user'),
(5, 'POSB-EMP0265', 'POSB', 'michelle.koh@dbs.com', 'Michelle Koh', '+65 63396666 ', 'bcc29ce057dd1d35ec3e783f07476f54f65a1fe3', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `fi_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(512) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `fi_id`, `title`, `message`, `link`, `is_read`, `created_at`, `admin_id`) VALUES
(1, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:06:46', NULL),
(2, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:06:48', NULL),
(3, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:06:51', NULL),
(4, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:46:52', NULL),
(5, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:46:55', NULL),
(6, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 19:46:58', NULL),
(7, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:00:15', NULL),
(8, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:00:18', NULL),
(9, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:00:21', NULL),
(10, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:04:42', NULL),
(11, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:04:45', NULL),
(12, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:04:48', NULL),
(13, 4, 'Client Accepted', 'MAS accepted the risk status for client Rachel Tan Mei Ling.', NULL, 1, '2025-07-24 20:08:33', NULL),
(14, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:25:04', NULL),
(15, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:25:07', NULL),
(16, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 20:25:10', NULL),
(17, 4, 'Client Rejected', 'MAS rejected the risk status for client Rachel Tan Mei Ling. Reason: Following a thorough risk assessment, the client’s profile has been classified as high-risk due to multiple contributing factors, including jurisdictional sensitivity, transaction behavior patterns, and potential exposure to politically exposed persons (PEPs). Given our regulatory obligations and internal compliance thresholds, we are unable to proceed with onboarding this client to ensure alignment with our institution’s risk management policies.', NULL, 1, '2025-07-24 20:26:43', NULL),
(18, 1, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 21:13:41', NULL),
(19, 2, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 21:13:44', NULL),
(20, 3, 'Risk Assessment Request', 'Maybank sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 21:13:46', NULL),
(21, 1, 'Risk Assessment Request', 'MAS sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 23:41:55', NULL),
(22, 3, 'Risk Assessment Request', 'MAS sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 23:41:57', NULL),
(23, 4, 'Risk Assessment Request', 'MAS sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-24 23:42:02', NULL),
(24, 2, 'Client Accepted', 'Maybank accepted the risk status for client Rachel Tan Mei Ling.', NULL, 1, '2025-07-24 23:43:02', NULL),
(25, 2, 'Client Accepted', 'Maybank accepted the risk status for client Rachel Tan Mei Ling.', NULL, 1, '2025-07-24 23:43:21', NULL),
(26, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:17:07', NULL),
(27, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:17:10', NULL),
(28, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:17:13', NULL),
(29, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:17:16', NULL),
(30, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:39:49', NULL),
(31, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:39:51', NULL),
(32, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:39:54', NULL),
(33, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 03:39:56', NULL),
(34, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 13:25:23', NULL),
(35, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 13:25:25', NULL),
(36, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 13:25:28', NULL),
(37, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-25 13:25:30', NULL),
(38, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:41', NULL),
(39, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:42', NULL),
(40, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:44', NULL),
(41, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:45', NULL),
(42, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:46', NULL),
(43, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:48', NULL),
(44, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:49', NULL),
(45, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:51:51', NULL),
(46, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:57:54', NULL),
(47, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:57:57', NULL),
(48, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:57:59', NULL),
(49, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 15:58:02', NULL),
(50, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 16:12:44', NULL),
(51, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 16:12:47', NULL),
(52, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 16:12:50', NULL),
(53, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-26 16:12:53', NULL),
(54, 5, 'New FI Registered', 'A new Financial Institution (POSB) has been registered.', NULL, 1, '2025-07-27 02:21:24', NULL),
(55, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 02:47:59', NULL),
(56, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 02:47:59', NULL),
(57, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 02:48:02', NULL),
(58, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 02:55:14', NULL),
(59, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 02:55:14', NULL),
(60, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 02:55:18', NULL),
(61, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 02:57:21', NULL),
(62, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 02:57:21', NULL),
(63, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 02:57:24', NULL),
(64, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 03:12:24', NULL),
(65, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 03:12:24', NULL),
(66, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 03:12:27', NULL),
(67, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 08:35:47', NULL),
(68, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 08:35:47', NULL),
(69, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 08:35:50', NULL),
(70, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 08:52:01', NULL),
(71, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 08:52:01', NULL),
(72, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 08:52:04', NULL),
(73, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 08:56:40', NULL),
(74, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 08:56:43', NULL),
(75, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 08:56:45', NULL),
(76, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 08:56:48', NULL),
(77, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 09:09:59', NULL),
(78, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 09:09:59', NULL),
(79, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 09:10:01', NULL),
(80, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:10:05', NULL),
(81, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:10:08', NULL),
(82, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:10:11', NULL),
(83, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:10:13', NULL),
(84, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan Mei Ling.', NULL, 1, '2025-07-27 09:30:32', NULL),
(85, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan Mei Ling) was added.', NULL, 1, '2025-07-27 09:30:32', NULL),
(86, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 09:30:35', NULL),
(87, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:30:43', NULL),
(88, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:30:46', NULL),
(89, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:30:49', NULL),
(90, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan Mei Ling. Response required.', NULL, 1, '2025-07-27 09:30:51', NULL),
(91, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan) was added.', NULL, 1, '2025-07-27 09:50:36', NULL),
(92, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 09:50:47', NULL),
(93, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 09:50:49', NULL),
(94, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 09:50:52', NULL),
(95, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 09:50:55', NULL),
(96, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan) was added.', NULL, 1, '2025-07-27 10:22:20', NULL),
(97, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:22:27', NULL),
(98, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:22:30', NULL),
(99, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:22:37', NULL),
(100, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:22:40', NULL),
(101, 5, 'Duplicate Client', 'Duplicate NRIC detected for Isabella Tan.', NULL, 1, '2025-07-27 10:31:51', NULL),
(102, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan) was added.', NULL, 1, '2025-07-27 10:31:51', NULL),
(103, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:32:08', NULL),
(104, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:32:13', NULL),
(105, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:32:15', NULL),
(106, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:32:18', NULL),
(107, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan) was added.', NULL, 1, '2025-07-27 10:37:30', NULL),
(108, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:37:36', NULL),
(109, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:37:38', NULL),
(110, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:37:40', NULL),
(111, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:37:43', NULL),
(112, 5, 'Client Blocked', 'POSB blocked client Isabella Tan.', NULL, 1, '2025-07-27 10:38:39', NULL),
(113, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:56:53', NULL),
(114, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:56:56', NULL),
(115, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:56:58', NULL),
(116, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 10:57:00', NULL),
(117, 5, 'Client Allowed for Further Assessment', 'POSB allowed client Isabella Tan for further assessment. Reason: Transaction activity is consistent with the client’s stated profile and business.', NULL, 1, '2025-07-27 11:02:50', NULL),
(118, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:06:37', NULL),
(119, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:06:40', NULL),
(120, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:06:43', NULL),
(121, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:06:46', NULL),
(122, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:08:23', NULL),
(123, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:08:26', NULL),
(124, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:08:28', NULL),
(125, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 11:08:30', NULL),
(126, 5, 'Client Allowed for Further Assessment', 'POSB allowed client Isabella Tan for further assessment. Reason: Transaction activity is consistent with the client’s stated profile and business.', NULL, 1, '2025-07-27 11:09:58', NULL),
(127, 5, 'Client Allowed for Further Assessment', 'GLDB allowed client Isabella Tan for further assessment. Reason: Transaction activity is consistent with the client’s stated profile and business.', NULL, 1, '2025-07-27 11:15:56', NULL),
(128, 5, 'Client Allowed for Further Assessment', 'MAS allowed client Isabella Tan for further assessment. Reason: All due diligence and KYC requirements have been satisfactorily met.', NULL, 1, '2025-07-27 11:21:41', NULL),
(129, 5, 'Client Allowed for Further Assessment', 'OCBC allowed client Isabella Tan for further assessment. Reason: Nil', NULL, 1, '2025-07-27 11:23:34', NULL),
(130, 5, 'Client Allowed for Further Assessment', 'Maybank allowed client Isabella Tan for further assessment. Reason: Nil', NULL, 1, '2025-07-27 11:26:22', NULL),
(133, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:10:14', NULL),
(134, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:12:20', NULL),
(135, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:13:00', NULL),
(136, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:14:57', NULL),
(137, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:20:22', NULL),
(138, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:20:25', NULL),
(139, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:20:27', NULL),
(140, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:20:30', NULL),
(141, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:20:33', NULL),
(142, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:23:36', NULL),
(143, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:25:03', NULL),
(144, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:25:06', NULL),
(145, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:25:08', NULL),
(146, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:25:11', NULL),
(147, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:25:14', NULL),
(148, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:39:47', NULL),
(149, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:41:16', NULL),
(150, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:45:44', NULL),
(151, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:48:32', NULL),
(152, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:53:05', NULL),
(153, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:53:08', NULL),
(154, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:53:11', NULL),
(155, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:53:14', NULL),
(156, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:53:17', NULL),
(157, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:56:41', NULL),
(158, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:56:44', NULL),
(159, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:56:47', NULL),
(160, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:56:49', NULL),
(161, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:56:52', NULL),
(162, 5, 'Client Updated', 'Client (Isabella Tan) information was updated.', NULL, 1, '2025-07-27 12:58:26', NULL),
(163, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:58:28', NULL),
(164, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:58:31', NULL),
(165, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 0, '2025-07-27 12:58:33', NULL),
(166, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan. Response required.', NULL, 1, '2025-07-27 12:58:36', NULL),
(167, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan.', NULL, 1, '2025-07-27 13:06:33', NULL),
(168, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan) was added.', NULL, 1, '2025-07-27 13:06:33', NULL),
(169, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 13:06:35', NULL),
(170, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:07:05', NULL),
(171, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:07:09', NULL),
(172, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:07:11', NULL),
(173, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:07:13', NULL),
(174, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:08:08', NULL),
(175, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:09:41', NULL),
(176, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:14:38', NULL),
(177, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:14:40', NULL),
(178, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:14:43', NULL),
(179, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:14:45', NULL),
(180, 5, 'Client Blocked', 'POSB blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:15:20', NULL),
(181, 5, 'Client Blocked', 'POSB blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:15:34', NULL),
(182, 5, 'Client Blocked', 'POSB blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:16:04', NULL),
(183, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan.', NULL, 1, '2025-07-27 13:19:05', NULL),
(184, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan) was added.', NULL, 1, '2025-07-27 13:19:05', NULL),
(185, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 13:19:08', NULL),
(186, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:19:37', NULL),
(187, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:19:39', NULL),
(188, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:19:42', NULL),
(189, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:19:45', NULL),
(190, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:21:06', NULL),
(191, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:22:12', NULL),
(192, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:36:50', NULL),
(193, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:36:52', NULL),
(194, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:36:55', NULL),
(195, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:36:58', NULL),
(196, 5, 'Client Blocked', 'POSB blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:37:15', NULL),
(197, 5, 'Client Blocked', 'POSB blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:37:31', NULL),
(198, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:38:36', NULL),
(199, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:39:14', NULL),
(200, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan) was added.', NULL, 1, '2025-07-27 13:45:47', NULL),
(201, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 13:45:57', NULL),
(202, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:45:59', NULL),
(203, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:46:02', NULL),
(204, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 13:46:05', NULL),
(205, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:47:07', NULL),
(206, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan.', NULL, 1, '2025-07-27 13:47:52', NULL),
(207, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan .', NULL, 1, '2025-07-27 14:01:43', NULL),
(208, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan ) was added.', NULL, 1, '2025-07-27 14:01:43', NULL),
(209, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 14:01:46', NULL),
(210, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 1, '2025-07-27 14:08:04', NULL),
(211, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 14:08:06', NULL),
(212, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 14:08:10', NULL),
(213, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 14:08:13', NULL),
(214, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan .', NULL, 1, '2025-07-27 14:09:06', NULL),
(215, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan .', NULL, 1, '2025-07-27 14:09:47', NULL),
(216, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan.', NULL, 1, '2025-07-27 14:20:18', NULL),
(217, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan) was added.', NULL, 1, '2025-07-27 14:20:18', NULL),
(218, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 14:20:21', NULL),
(219, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 1, '2025-07-27 14:20:28', NULL),
(220, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 14:20:31', NULL),
(221, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 14:20:33', NULL),
(222, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan. Response required.', NULL, 0, '2025-07-27 14:20:36', NULL),
(223, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan.', NULL, 1, '2025-07-27 14:21:26', NULL),
(224, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan.', NULL, 1, '2025-07-27 14:22:01', NULL),
(225, 5, 'Client Blocked', 'GLDB blocked client Rachel Tan.', NULL, 1, '2025-07-27 14:23:21', NULL),
(226, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Rachel Tan .', NULL, 1, '2025-07-27 16:09:00', NULL),
(227, 5, 'PEP Detected', 'A client marked as PEP (Rachel Tan ) was added.', NULL, 1, '2025-07-27 16:09:00', NULL),
(228, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-27 16:09:04', NULL),
(229, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 1, '2025-07-27 16:09:07', NULL),
(230, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 16:09:11', NULL),
(231, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 16:09:13', NULL),
(232, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-27 16:09:16', NULL),
(233, 5, 'Client Blocked', 'Maybank blocked client Rachel Tan .', NULL, 1, '2025-07-27 16:10:00', NULL),
(234, 5, 'Client Blocked', 'GLDB blocked client Rachel Tan .', NULL, 1, '2025-07-27 16:10:33', NULL),
(235, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 1, '2025-07-28 00:33:34', NULL),
(236, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 00:33:37', NULL),
(237, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 00:33:42', NULL),
(238, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 00:33:45', NULL),
(239, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan .', NULL, 1, '2025-07-28 00:36:02', NULL),
(240, 5, 'Client Blocked', 'GLDB blocked client Rachel Tan .', NULL, 1, '2025-07-28 00:37:06', NULL),
(241, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 1, '2025-07-28 01:14:37', NULL),
(242, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 01:14:39', NULL),
(243, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 01:14:42', NULL),
(244, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Rachel Tan . Response required.', NULL, 0, '2025-07-28 01:14:44', NULL),
(245, 5, 'Client Blocked', 'OCBC blocked client Rachel Tan .', NULL, 1, '2025-07-28 01:16:34', NULL),
(246, 5, 'Client Blocked', 'GLDB blocked client Rachel Tan .', NULL, 1, '2025-07-28 01:17:50', NULL),
(247, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:38:53', NULL),
(248, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan Mei Ling) was added.', NULL, 1, '2025-07-28 01:38:53', NULL),
(249, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-28 01:38:56', NULL),
(250, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 1, '2025-07-28 01:39:02', NULL),
(251, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:39:05', NULL),
(252, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:39:07', NULL),
(253, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:39:10', NULL),
(254, 5, 'Client Blocked', 'POSB blocked client Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:39:41', NULL),
(255, 5, 'Client Blocked', 'POSB blocked client Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:40:08', NULL),
(256, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 1, '2025-07-28 01:44:27', NULL),
(257, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:44:31', NULL),
(258, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:44:34', NULL),
(259, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:44:36', NULL),
(260, 5, 'Duplicate Medium-Risk Client', 'Duplicate NRIC with medium-risk client detected for Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:54:50', NULL),
(261, 5, 'PEP Detected', 'A client marked as PEP (Isabella Tan Mei Ling) was added.', NULL, 1, '2025-07-28 01:54:50', NULL),
(262, 5, 'CRITICAL AML ALERT', 'A client with NRIC S1234567D matches a blacklisted client in the system. Immediate review required.', NULL, 1, '2025-07-28 01:54:53', NULL),
(263, 1, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 1, '2025-07-28 01:54:56', NULL),
(264, 2, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:54:59', NULL),
(265, 3, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:55:02', NULL),
(266, 4, 'Risk Assessment Request', 'POSB sent a risk assessment for client Isabella Tan Mei Ling. Response required.', NULL, 0, '2025-07-28 01:55:04', NULL),
(267, 5, 'Client Blocked', 'Maybank blocked client Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:58:58', NULL),
(268, 5, 'Client Blocked', 'OCBC blocked client Isabella Tan Mei Ling.', NULL, 1, '2025-07-28 01:59:41', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `transaction_type` enum('credit_cash','credit_wire','credit_crypto','credit_cheque','credit_card','debit_cash','debit_wire','debit_crypto','debit_cheque','debit_card') DEFAULT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `transaction_status` enum('pending','approved','rejected') DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `risk_score` int(11) DEFAULT NULL,
  `red_flags` text DEFAULT NULL,
  `alert_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `client_id`, `amount`, `transaction_type`, `transaction_date`, `transaction_status`, `country`, `risk_score`, `red_flags`, `alert_id`) VALUES
(1, 1, 12000.50, 'credit_wire', '2025-07-20 02:15:00', 'approved', 'Singapore', 75, 'Large cash deposit', 'AL101'),
(2, 2, 3500.00, 'debit_card', '2025-07-18 06:30:00', 'approved', 'Malaysia', 42, '', NULL),
(3, 3, 8000.00, 'credit_crypto', '2025-07-17 01:00:00', 'rejected', 'USA', 88, 'PEP involved', 'AL102'),
(4, 3, 1500.00, 'debit_cash', '2025-07-26 18:13:12', 'approved', 'UK', 33, '', NULL),
(5, 5, 22000.00, 'credit_cheque', '2025-07-14 03:20:00', 'pending', 'China', 60, 'Structuring', NULL),
(6, 3, 5000.00, 'debit_wire', '2025-07-26 18:14:49', 'approved', 'India', 55, '', NULL),
(7, 5, 9500.00, 'credit_card', '2025-07-26 18:13:12', 'approved', 'Nigeria', 39, '', NULL),
(8, 4, 3000.00, 'debit_cheque', '2025-07-26 18:14:49', 'rejected', 'Iran', 92, 'Unusual country', 'AL103'),
(9, 1, 7000.00, 'credit_cash', '2025-07-10 04:00:00', 'approved', 'Singapore', 48, '', NULL),
(10, 2, 12000.00, 'debit_crypto', '2025-07-09 07:40:00', 'approved', 'Malaysia', 65, 'Rapid movement', NULL),
(11, 12, 19323.00, 'credit_wire', '2025-07-25 05:08:39', 'approved', 'Iranian', 50, '', NULL),
(12, 13, 17948.00, 'credit_wire', '2025-07-25 05:16:54', 'approved', 'Iranian', 50, '', NULL),
(13, 14, 15165.00, 'credit_wire', '2025-07-25 05:17:03', 'approved', 'Iranian', 50, '', NULL),
(14, 15, 17062.00, 'credit_wire', '2025-07-25 05:20:47', 'approved', 'Singaporean', 50, '', NULL),
(15, 10, 16421.36, 'credit_card', '2025-07-26 19:12:24', 'pending', 'Singaporean', 5, NULL, NULL),
(16, 11, 10326.33, 'debit_crypto', '2025-07-27 00:35:47', 'rejected', 'Singaporean', 36, NULL, NULL),
(17, 12, 12431.20, 'debit_cheque', '2025-07-27 00:52:01', 'approved', 'Singaporean', 76, NULL, NULL),
(18, 13, 12235.15, 'credit_wire', '2025-07-27 01:09:59', 'rejected', 'Singaporean', 63, NULL, NULL),
(19, 14, 13292.69, 'credit_cheque', '2025-07-27 01:30:32', 'pending', 'Iranian', 12, NULL, NULL),
(20, 15, 19752.52, 'debit_crypto', '2025-07-27 01:50:36', 'rejected', 'Singaporean', 51, NULL, NULL),
(21, 16, 19159.89, 'credit_cheque', '2025-07-27 02:22:20', 'approved', 'Singaporean', 59, NULL, NULL),
(22, 17, 1577.98, 'debit_cheque', '2025-07-27 02:31:51', 'approved', 'Singaporean', 21, 'Duplicate NRIC detected', NULL),
(23, 18, 14032.61, 'debit_cheque', '2025-07-27 02:37:30', 'approved', 'Singaporean', 27, NULL, NULL),
(24, 18, 5640.16, 'credit_wire', '2025-07-27 03:57:38', 'pending', 'Singaporean', 70, NULL, NULL),
(25, 18, 13530.81, 'credit_wire', '2025-07-27 04:00:21', 'rejected', 'Singaporean', 9, NULL, NULL),
(26, 18, 3749.73, 'debit_cheque', '2025-07-27 04:10:14', 'pending', 'Singaporean', 98, NULL, NULL),
(27, 18, 18080.98, 'debit_card', '2025-07-27 04:12:20', 'pending', 'Singaporean', 89, NULL, NULL),
(28, 18, 1125.13, 'credit_wire', '2025-07-27 04:13:00', 'rejected', 'Singaporean', 3, NULL, NULL),
(29, 18, 718.13, 'debit_card', '2025-07-27 04:14:57', 'pending', 'Singaporean', 20, NULL, NULL),
(30, 18, 12968.51, 'credit_crypto', '2025-07-27 04:20:22', 'rejected', 'Singaporean', 81, NULL, NULL),
(31, 18, 19554.86, 'debit_cheque', '2025-07-27 04:23:36', 'pending', 'Singaporean', 11, NULL, NULL),
(32, 18, 14379.52, 'debit_wire', '2025-07-27 04:25:03', 'rejected', 'Singaporean', 96, NULL, NULL),
(33, 18, 15325.70, 'debit_cheque', '2025-07-27 04:39:47', 'approved', 'Singaporean', 31, NULL, NULL),
(34, 18, 4648.79, 'debit_crypto', '2025-07-27 04:41:16', 'pending', 'Singaporean', 90, NULL, NULL),
(35, 18, 15687.94, 'credit_wire', '2025-07-27 04:45:44', 'pending', 'Singaporean', 18, NULL, NULL),
(36, 18, 7583.59, 'credit_crypto', '2025-07-27 04:48:32', 'rejected', 'Singaporean', 79, NULL, NULL),
(37, 18, 12702.41, 'credit_card', '2025-07-27 04:53:05', 'rejected', 'Singaporean', 19, NULL, NULL),
(38, 18, 18017.92, 'credit_card', '2025-07-27 04:56:41', 'pending', 'Singaporean', 60, NULL, NULL),
(39, 18, 7696.53, 'credit_cash', '2025-07-27 04:58:26', 'approved', 'Singaporean', 55, NULL, NULL),
(40, 19, 14334.41, 'debit_crypto', '2025-07-27 05:06:33', 'pending', 'Singaporean ', 17, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(41, 20, 8902.26, 'debit_card', '2025-07-27 05:19:05', 'approved', 'Singaporean', 24, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(42, 21, 13518.96, 'credit_card', '2025-07-27 05:45:47', 'approved', 'Singaporean', 23, NULL, NULL),
(43, 22, 11048.10, 'credit_crypto', '2025-07-27 06:01:43', 'pending', 'Singaporean', 73, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(44, 23, 7819.51, 'debit_cheque', '2025-07-27 06:20:18', 'approved', 'Singaporean', 5, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(45, 24, 20017.65, 'debit_cash', '2025-07-27 08:09:00', 'approved', 'Singaporean', 58, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(46, 25, 3809.95, 'credit_crypto', '2025-07-27 17:38:53', 'approved', 'Singaporean', 64, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL),
(47, 26, 3021.79, 'credit_cash', '2025-07-27 17:54:50', 'pending', 'Singaporean', 35, 'Potential identity misuse: Duplicate NRIC with medium-risk client', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(16) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(60) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role` varchar(45) DEFAULT NULL,
  `FI_id` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `employee_id` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `email`, `password`, `create_time`, `role`, `FI_id`, `image`, `employee_id`) VALUES
(1, 'braydonkly', 'braydonxly@gmail.com', 'b86f6db284d374188d561d46b45b188d5631609a', '2025-07-28 02:38:56', 'admin', NULL, 'bk.jpg', 'TRACEFI-ADM1503');

-- --------------------------------------------------------

--
-- Table structure for table `verification`
--

CREATE TABLE `verification` (
  `verification_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `response` enum('approved','rejected','pending') DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `verification`
--

INSERT INTO `verification` (`verification_id`, `client_id`, `response`, `verified_by`, `reason`) VALUES
(1, 13, 'approved', 5, NULL),
(2, 13, 'approved', 5, NULL),
(3, 15, 'approved', 5, NULL),
(4, 15, 'approved', 5, NULL),
(5, 15, 'approved', 2, NULL),
(6, 15, 'approved', 2, NULL),
(7, 19, 'approved', 5, NULL),
(8, 19, 'approved', 5, NULL),
(9, 19, 'rejected', 5, ''),
(10, 19, 'approved', 5, NULL),
(11, 20, 'approved', 5, NULL),
(12, 20, 'approved', 5, NULL),
(13, 20, 'approved', 5, NULL),
(14, 21, 'approved', 5, NULL),
(15, 21, 'approved', 5, NULL),
(16, 21, 'approved', 5, NULL),
(17, 22, 'approved', 5, NULL),
(18, 23, 'approved', 5, NULL),
(19, 23, 'rejected', 5, ''),
(20, 23, 'approved', 5, NULL),
(21, 24, 'rejected', 2, 'After internal review, we have determined that the client presents a level of financial and reputational risk that exceeds our institution’s acceptable risk appetite. The combination of jurisdictional exposure, occupation, and source of funds has triggered multiple red flags under our AML/CFT policy framework. In accordance with our customer due diligence (CDD) and onboarding standards, we are unable to proceed with this client at this time.'),
(22, 25, 'approved', 5, NULL),
(23, 30, 'approved', 2, NULL),
(24, 30, 'rejected', 5, 'After internal review, we have determined that the client presents a level of financial and reputational risk that exceeds our institution’s acceptable risk appetite. The combination of jurisdictional exposure, occupation, and source of funds has triggered multiple red flags under our AML/CFT policy framework. In accordance with our customer due diligence (CDD) and onboarding standards, we are unable to proceed with this client at this time.'),
(25, 30, 'rejected', 5, 'Following a thorough risk assessment, the client’s profile has been classified as high-risk due to multiple contributing factors, including jurisdictional sensitivity, transaction behavior patterns, and potential exposure to politically exposed persons (PEPs). Given our regulatory obligations and internal compliance thresholds, we are unable to proceed with onboarding this client to ensure alignment with our institution’s risk management policies.'),
(26, 31, 'rejected', 2, 'Following a thorough risk assessment, the client’s profile has been classified as high-risk due to multiple contributing factors, including jurisdictional sensitivity, transaction behavior patterns, and potential exposure to politically exposed persons (PEPs). Given our regulatory obligations and internal compliance thresholds, we are unable to proceed with onboarding this client to ensure alignment with our institution’s risk management policies.'),
(27, 31, 'approved', 5, NULL),
(28, 31, 'approved', 5, NULL),
(29, 39, 'approved', 5, NULL),
(30, 39, 'approved', 5, NULL),
(31, 10, 'approved', 4, NULL),
(32, 10, 'approved', 4, NULL),
(33, 11, 'approved', 4, NULL),
(34, 11, 'approved', 4, NULL),
(35, 16, 'approved', 4, NULL),
(36, 16, 'approved', 4, NULL),
(37, 16, 'rejected', 5, 'Nil'),
(38, 19, 'rejected', 2, 'The client\'s risk profile exceeds the institution\'s acceptable risk appetite, particularly due to insufficient transparency in the source of funds, high exposure to high-risk jurisdictions, and inadequate controls to mitigate money laundering and terrorist financing risks. As a result, the institution is unable to establish or maintain a business relationship in accordance with internal compliance standards and regulatory expectations.'),
(39, 19, 'approved', 4, NULL),
(40, 19, 'approved', 4, NULL),
(41, 19, 'approved', 3, NULL),
(42, 18, '', 5, NULL),
(43, 18, 'rejected', 5, 'Transaction activity is consistent with the client’s stated profile and business.'),
(44, 18, 'rejected', 5, 'Transaction activity is consistent with the client’s stated profile and business.'),
(45, 18, 'rejected', 3, 'Transaction activity is consistent with the client’s stated profile and business.'),
(46, 18, 'rejected', 2, 'All due diligence and KYC requirements have been satisfactorily met.'),
(47, 18, 'rejected', 1, 'Nil'),
(48, 18, 'rejected', 4, 'Nil'),
(49, 19, '', 4, NULL),
(50, 19, '', 1, NULL),
(51, 19, '', 5, NULL),
(52, 19, '', 5, NULL),
(53, 19, '', 5, NULL),
(54, 20, '', 4, NULL),
(55, 20, '', 1, NULL),
(56, 20, '', 5, NULL),
(57, 20, '', 5, NULL),
(58, 20, '', 4, NULL),
(59, 20, '', 1, NULL),
(60, 21, '', 4, NULL),
(61, 21, '', 1, NULL),
(62, 22, '', 4, NULL),
(63, 22, '', 1, NULL),
(64, 23, '', 4, NULL),
(65, 23, '', 1, NULL),
(66, 23, '', 3, NULL),
(67, 24, '', 4, NULL),
(68, 24, '', 3, NULL),
(69, 24, '', 1, NULL),
(70, 24, '', 3, NULL),
(71, 24, '', 1, NULL),
(72, 24, '', 3, NULL),
(73, 25, '', 5, NULL),
(74, 25, '', 5, NULL),
(75, 26, 'approved', 4, NULL),
(76, 26, 'approved', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `FI_id` (`FI_id`);

--
-- Indexes for table `financial_institute`
--
ALTER TABLE `financial_institute`
  ADD PRIMARY KEY (`FI_id`),
  ADD UNIQUE KEY `employee_id` (`employee_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fi_id` (`fi_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_user_FI` (`FI_id`);

--
-- Indexes for table `verification`
--
ALTER TABLE `verification`
  ADD PRIMARY KEY (`verification_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `verified_by` (`verified_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `financial_institute`
--
ALTER TABLE `financial_institute`
  MODIFY `FI_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `verification`
--
ALTER TABLE `verification`
  MODIFY `verification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`fi_id`) REFERENCES `financial_institute` (`FI_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
