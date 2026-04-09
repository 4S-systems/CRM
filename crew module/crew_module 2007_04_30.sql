-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.24-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema maintenance
--

CREATE DATABASE IF NOT EXISTS maintenance;
USE maintenance;

--
-- Definition of table `crew_employee`
--

DROP TABLE IF EXISTS `crew_mission`;
CREATE TABLE `crew_mission` (
  `CREW_ID` varchar(50) NOT NULL,
  `CREW_CODE` varchar(100) NOT NULL,
  `MISSION_DESC` text NOT NULL,
  `TYPICAL_DURATION` int(10) unsigned NOT NULL,
  `TYPICAL_COST` float NOT NULL,
  `CREATED_BY` varchar(100) NOT NULL,
  `CREATION_TIME` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `CREW_NAME` varchar(100) NOT NULL,
  PRIMARY KEY  (`CREW_ID`),
  KEY `FK_crew_mission_user` (`CREATED_BY`),
  CONSTRAINT `FK_crew_mission_user` FOREIGN KEY (`CREATED_BY`) REFERENCES `users` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `staff_code`;
CREATE TABLE `staff_code` (
  `ID` varchar(50) NOT NULL,
  `CODE` varchar(45) NOT NULL,
  `temp_fieldname` varchar(50) NOT NULL,
  `DESCRIPTION` varchar(100) NOT NULL,
  `CREATION_TIME` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `CREATED_BY` varchar(45) NOT NULL,
  `CREW_ID` varchar(50) NOT NULL,
  `CREW_STAFF_NAME` varchar(255) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `FK_staff_code_crew` (`CREW_ID`),
  KEY `FK_staff_code_creator` (`CREATED_BY`),
  CONSTRAINT `FK_staff_code_creator` FOREIGN KEY (`CREATED_BY`) REFERENCES `users` (`USER_ID`),
  CONSTRAINT `FK_staff_code_crew` FOREIGN KEY (`CREW_ID`) REFERENCES `crew_mission` (`CREW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `crew_employee`;
CREATE TABLE `crew_employee` (
  `ID` varchar(50) NOT NULL,
  `CREW_STAFF_ID` varchar(50) NOT NULL,
  `EMPLOYEE_ID` varchar(50) NOT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `CREATION_TIME` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`ID`),
  KEY `FK_crew_employee_emp` (`EMPLOYEE_ID`),
  KEY `FK_crew_employee_user` (`CREATED_BY`),
  KEY `FK_crew_staff` (`CREW_STAFF_ID`),
  CONSTRAINT `FK_crew_staff` FOREIGN KEY (`CREW_STAFF_ID`) REFERENCES `staff_code` (`ID`),
  CONSTRAINT `FK_crew_employee_emp` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `employee` (`EMP_ID`),
  CONSTRAINT `FK_crew_employee_user` FOREIGN KEY (`CREATED_BY`) REFERENCES `users` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
