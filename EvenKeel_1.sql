# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.2.7-MariaDB)
# Database: EvenKeel
# Generation Time: 2017-08-25 01:02:17 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table AthleteStatHistory
# ------------------------------------------------------------

DROP TABLE IF EXISTS `AthleteStatHistory`;

CREATE TABLE `AthleteStatHistory` (
  `AthleteStatHistoryID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(11) unsigned NOT NULL,
  `AthleteStatTypeID` int(11) unsigned NOT NULL,
  `Centimeters` float NOT NULL,
  `CreateDT` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`AthleteStatHistoryID`),
  KEY `UserID` (`UserID`),
  KEY `AthleteStatTypeID` (`AthleteStatTypeID`),
  CONSTRAINT `athletestathistory_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `athletestathistory_ibfk_2` FOREIGN KEY (`AthleteStatTypeID`) REFERENCES `lkathletestattype` (`AthleteStatTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table HeartRates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `HeartRates`;

CREATE TABLE `HeartRates` (
  `HeartRateID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `HeartRateTypeID` int(11) unsigned NOT NULL,
  `BPM` int(3) unsigned NOT NULL,
  `UserID` int(11) unsigned NOT NULL,
  `CreateDT` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`HeartRateID`),
  KEY `HeartRateTypeID` (`HeartRateTypeID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `heartrates_ibfk_1` FOREIGN KEY (`HeartRateTypeID`) REFERENCES `lkheartratetype` (`HeartRateTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `heartrates_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table LKAthleteStatType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKAthleteStatType`;

CREATE TABLE `LKAthleteStatType` (
  `AthleteStatTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `AthleteStatTypeDescription` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`AthleteStatTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKAthleteStatType` WRITE;
/*!40000 ALTER TABLE `LKAthleteStatType` DISABLE KEYS */;

INSERT INTO `LKAthleteStatType` (`AthleteStatTypeID`, `AthleteStatTypeDescription`)
VALUES
	(1,'Height'),
	(2,'Weight'),
	(3,'Wingspan');

/*!40000 ALTER TABLE `LKAthleteStatType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKDesiredIntensityType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKDesiredIntensityType`;

CREATE TABLE `LKDesiredIntensityType` (
  `DesiredIntensityTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `DesiredIntensityTypeDescription` varchar(60) NOT NULL DEFAULT '',
  `OwnerTypeID` int(11) unsigned NOT NULL,
  `OwnerID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`DesiredIntensityTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKDesiredIntensityType` WRITE;
/*!40000 ALTER TABLE `LKDesiredIntensityType` DISABLE KEYS */;

INSERT INTO `LKDesiredIntensityType` (`DesiredIntensityTypeID`, `DesiredIntensityTypeDescription`, `OwnerTypeID`, `OwnerID`)
VALUES
	(1,'Percentage',1,NULL),
	(2,'1-5',1,NULL);

/*!40000 ALTER TABLE `LKDesiredIntensityType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKHeartRateType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKHeartRateType`;

CREATE TABLE `LKHeartRateType` (
  `HeartRateTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `HeartRateTypeDescription` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`HeartRateTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKHeartRateType` WRITE;
/*!40000 ALTER TABLE `LKHeartRateType` DISABLE KEYS */;

INSERT INTO `LKHeartRateType` (`HeartRateTypeID`, `HeartRateTypeDescription`)
VALUES
	(1,'Resting'),
	(2,'Workout'),
	(3,'Pre-workout'),
	(4,'Post-workout');

/*!40000 ALTER TABLE `LKHeartRateType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKOwnerType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKOwnerType`;

CREATE TABLE `LKOwnerType` (
  `OwnerTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `OwnerTypeDescription` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`OwnerTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKOwnerType` WRITE;
/*!40000 ALTER TABLE `LKOwnerType` DISABLE KEYS */;

INSERT INTO `LKOwnerType` (`OwnerTypeID`, `OwnerTypeDescription`)
VALUES
	(1,'System'),
	(2,'Organization'),
	(3,'Sport'),
	(4,'Squad'),
	(5,'User');

/*!40000 ALTER TABLE `LKOwnerType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKUserType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKUserType`;

CREATE TABLE `LKUserType` (
  `UserTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserTypeDescription` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`UserTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKUserType` WRITE;
/*!40000 ALTER TABLE `LKUserType` DISABLE KEYS */;

INSERT INTO `LKUserType` (`UserTypeID`, `UserTypeDescription`)
VALUES
	(1,'Athlete'),
	(2,'Coach'),
	(3,'Admin');

/*!40000 ALTER TABLE `LKUserType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKWorkoutSessionType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKWorkoutSessionType`;

CREATE TABLE `LKWorkoutSessionType` (
  `WorkoutSessionTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSessionTypeDescription` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`WorkoutSessionTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKWorkoutSessionType` WRITE;
/*!40000 ALTER TABLE `LKWorkoutSessionType` DISABLE KEYS */;

INSERT INTO `LKWorkoutSessionType` (`WorkoutSessionTypeID`, `WorkoutSessionTypeDescription`)
VALUES
	(1,'Athlete Workout'),
	(2,'Coach Workout Plan - Work in Progress'),
	(3,'Coach Workout Plan - Ready');

/*!40000 ALTER TABLE `LKWorkoutSessionType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKWorkoutSetType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKWorkoutSetType`;

CREATE TABLE `LKWorkoutSetType` (
  `WorkoutSetTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSetTypeDescriptoin` varchar(60) NOT NULL DEFAULT '',
  `OwnerTypeID` int(11) unsigned NOT NULL,
  `OwnerID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkoutSetTypeID`),
  KEY `WorkoutSetOwnerID` (`OwnerID`),
  KEY `OwnerTypeID` (`OwnerTypeID`),
  CONSTRAINT `lkworkoutsettype_ibfk_2` FOREIGN KEY (`OwnerID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `lkworkoutsettype_ibfk_3` FOREIGN KEY (`OwnerTypeID`) REFERENCES `lkownertype` (`OwnerTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `LKWorkoutSetType` WRITE;
/*!40000 ALTER TABLE `LKWorkoutSetType` DISABLE KEYS */;

INSERT INTO `LKWorkoutSetType` (`WorkoutSetTypeID`, `WorkoutSetTypeDescriptoin`, `OwnerTypeID`, `OwnerID`)
VALUES
	(1,'Erg',1,NULL),
	(2,'On the Water',1,NULL),
	(3,'Running',1,NULL),
	(4,'Biking',1,NULL),
	(5,'Weights',1,NULL);

/*!40000 ALTER TABLE `LKWorkoutSetType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserTypeID` int(11) unsigned DEFAULT NULL,
  `FirstName` varchar(60) DEFAULT NULL,
  `LastName` varchar(60) DEFAULT NULL,
  `Email` varchar(256) DEFAULT NULL,
  `Salt` char(128) DEFAULT NULL,
  `Password` char(128) DEFAULT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table Workout
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Workout`;

CREATE TABLE `Workout` (
  `WorkoutID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSessionID` int(10) unsigned NOT NULL,
  `WorkoutDescription` text DEFAULT NULL,
  `RequestCoachEndorsementDT` datetime DEFAULT NULL,
  `CoachEndorsementDT` datetime DEFAULT NULL,
  `EndorsedByUserID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkoutID`),
  KEY `WorkoutSessionID` (`WorkoutSessionID`),
  KEY `EndorsedByUserID` (`EndorsedByUserID`),
  CONSTRAINT `workout_ibfk_1` FOREIGN KEY (`WorkoutSessionID`) REFERENCES `workoutsession` (`WorkoutSessionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workout_ibfk_2` FOREIGN KEY (`EndorsedByUserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table WorkoutSession
# ------------------------------------------------------------

DROP TABLE IF EXISTS `WorkoutSession`;

CREATE TABLE `WorkoutSession` (
  `WorkoutSessionID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSessionTypeID` int(11) unsigned NOT NULL,
  `UserID` int(11) unsigned NOT NULL,
  `CreateDT` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`WorkoutSessionID`),
  KEY `WorkoutSessionTypeID` (`WorkoutSessionTypeID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `workoutsession_ibfk_1` FOREIGN KEY (`WorkoutSessionTypeID`) REFERENCES `lkworkoutsessiontype` (`WorkoutSessionTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workoutsession_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table WorkoutSets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `WorkoutSets`;

CREATE TABLE `WorkoutSets` (
  `WorkoutSetID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutID` int(11) unsigned NOT NULL,
  `WorkoutSetTypeID` int(11) unsigned NOT NULL,
  `Weight` float DEFAULT NULL,
  `Reps` smallint(6) DEFAULT NULL,
  `ExerciseTime` time(2) DEFAULT NULL,
  `SplitTime` time(2) DEFAULT NULL,
  `SPM` tinyint(3) DEFAULT NULL,
  `RestTime` time(2) DEFAULT NULL,
  `DesiredIntensity` tinyint(3) DEFAULT NULL,
  `DesiredIntensityTypeID` int(11) unsigned DEFAULT NULL,
  `HeartRateID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkoutSetID`),
  KEY `WorkoutSetTypeID` (`WorkoutSetTypeID`),
  CONSTRAINT `workoutsets_ibfk_1` FOREIGN KEY (`WorkoutSetTypeID`) REFERENCES `lkworkoutsettype` (`WorkoutSetTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
