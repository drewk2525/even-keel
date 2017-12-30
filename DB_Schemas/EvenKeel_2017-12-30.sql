# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.2.7-MariaDB)
# Database: EvenKeel
# Generation Time: 2017-12-30 20:59:20 +0000
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
  `Value` float NOT NULL,
  `CreateDT` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`AthleteStatHistoryID`),
  KEY `UserID` (`UserID`),
  KEY `AthleteStatTypeID` (`AthleteStatTypeID`),
  CONSTRAINT `athletestathistory_ibfk_3` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `athletestathistory_ibfk_4` FOREIGN KEY (`AthleteStatTypeID`) REFERENCES `LKAthleteStatType` (`AthleteStatTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;



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
  CONSTRAINT `heartrates_ibfk_3` FOREIGN KEY (`HeartRateTypeID`) REFERENCES `LKHeartRateType` (`HeartRateTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `heartrates_ibfk_4` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

LOCK TABLES `HeartRates` WRITE;
/*!40000 ALTER TABLE `HeartRates` DISABLE KEYS */;

INSERT INTO `HeartRates` (`HeartRateID`, `HeartRateTypeID`, `BPM`, `UserID`, `CreateDT`)
VALUES
	(16,4,140,63,'2017-10-31 22:27:58'),
	(17,2,160,63,'2017-10-31 22:28:20'),
	(19,3,90,63,'2017-10-31 22:28:27'),
	(20,1,50,63,'2017-10-31 22:28:32'),
	(21,1,55,63,'2017-11-01 04:20:37'),
	(22,2,120,63,'2017-11-01 04:20:48'),
	(23,4,110,63,'2017-11-01 04:20:52'),
	(24,4,110,63,'2017-11-01 04:20:52'),
	(25,4,110,63,'2017-11-01 04:20:54'),
	(26,2,165,63,'2017-11-03 01:14:41'),
	(27,2,170,63,'2017-11-03 01:14:47'),
	(28,2,155,63,'2017-11-03 01:14:53'),
	(29,2,180,63,'2017-11-03 01:14:57'),
	(30,1,122,63,'2017-11-06 03:32:13'),
	(31,3,65,63,'2017-11-20 01:19:29'),
	(32,3,65,63,'2017-11-20 01:19:34'),
	(33,1,65,63,'2017-11-20 01:49:36'),
	(34,1,45,63,'2017-11-20 01:49:59'),
	(35,3,80,63,'2017-11-20 01:50:23'),
	(36,2,185,63,'2017-11-20 01:52:43'),
	(37,2,65,63,'2017-11-20 01:57:05'),
	(38,2,165,63,'2017-11-20 01:59:12'),
	(39,1,50,63,'2017-11-20 02:23:38'),
	(40,1,42,63,'2017-11-20 02:28:05'),
	(41,1,48,63,'2017-11-20 02:31:07'),
	(42,3,123,63,'2017-11-20 02:44:45'),
	(43,1,36,63,'2017-11-20 02:51:03'),
	(44,2,160,63,'2017-11-20 03:03:21'),
	(45,2,180,63,'2017-11-20 03:03:34'),
	(46,1,65,63,'2017-11-20 03:09:09'),
	(47,1,62,63,'2017-11-20 03:12:16'),
	(48,1,64,63,'2017-11-23 01:15:16'),
	(49,3,150,63,'2017-12-07 01:44:43'),
	(50,2,135,63,'2017-12-20 20:56:48'),
	(51,2,123,63,'2017-12-30 18:34:28');

/*!40000 ALTER TABLE `HeartRates` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKAthleteStatType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKAthleteStatType`;

CREATE TABLE `LKAthleteStatType` (
  `AthleteStatTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `AthleteStatTypeDescription` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`AthleteStatTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

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
  `UserType` int(11) DEFAULT NULL,
  PRIMARY KEY (`WorkoutSessionTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

LOCK TABLES `LKWorkoutSessionType` WRITE;
/*!40000 ALTER TABLE `LKWorkoutSessionType` DISABLE KEYS */;

INSERT INTO `LKWorkoutSessionType` (`WorkoutSessionTypeID`, `WorkoutSessionTypeDescription`, `UserType`)
VALUES
	(1,'Athlete Workout',NULL),
	(2,'Coach Workout Plan - Work in Progress',2),
	(3,'Coach Workout Plan - Ready',2);

/*!40000 ALTER TABLE `LKWorkoutSessionType` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table LKWorkoutSetType
# ------------------------------------------------------------

DROP TABLE IF EXISTS `LKWorkoutSetType`;

CREATE TABLE `LKWorkoutSetType` (
  `WorkoutSetTypeID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSetTypeDescription` varchar(60) NOT NULL DEFAULT '',
  `OwnerTypeID` int(11) unsigned NOT NULL,
  `OwnerID` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkoutSetTypeID`),
  KEY `OwnerID` (`OwnerID`),
  KEY `OwnerTypeID` (`OwnerTypeID`),
  CONSTRAINT `lkworkoutsettype_ibfk_4` FOREIGN KEY (`OwnerID`) REFERENCES `Users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `lkworkoutsettype_ibfk_6` FOREIGN KEY (`OwnerTypeID`) REFERENCES `LKOwnerType` (`OwnerTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

LOCK TABLES `LKWorkoutSetType` WRITE;
/*!40000 ALTER TABLE `LKWorkoutSetType` DISABLE KEYS */;

INSERT INTO `LKWorkoutSetType` (`WorkoutSetTypeID`, `WorkoutSetTypeDescription`, `OwnerTypeID`, `OwnerID`)
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
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `UserTypeID` (`UserTypeID`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`UserTypeID`) REFERENCES `LKUserType` (`UserTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;

INSERT INTO `Users` (`UserID`, `UserTypeID`, `FirstName`, `LastName`, `Email`, `Salt`, `Password`)
VALUES
	(51,1,'Katherine','Pohl','katie@google.com','83pHnAQCo2yQjh5wPVBBdpZuAmMn13ch5pJBAb3CAqZD6XhDC48LQ1hkD5seYE6ZfxT9Z8OcEBWrF9PXuOQD6l371tB86WwE1winw7DmoyGFkLfpYsmAHk6LaFmoKwEY','bb061ec26655ec5bcf13958a401fa276c10406d9b7d54ff7962f22f98fe35522d765401139b66565f164d37d3cebf1223d0532eb42095adfd183a9ed31141e7b'),
	(52,3,'Mark','Cross','cross.ryan.mark@gmail.com','8OEett5S8funkkzaGtknXWbC4NTXJg8qtiXiweVnhpdjoWSYQRniT19K7NnO9Xa1SmESImYAQunu2CXKal7cRNWSiYkfEijNPe3XJ2LEo7iCpfWlIAlt489TtUyoGVe5','f08d641e27204804dc9a810a508c3dda20a3cd9bba0fa03d0ebe489bdeb73f9b9b5cc698f37d466f5d8f52f868c5957dd92516a9e9dfebaed5a12657b90b671f'),
	(63,1,'drew','kroft','drewk2525@yahoo.com','MjeURiKPqUReeXORSkbLdWc9Jp1oaa8rPttTvR97nlmcgz40D364gfTcDKz6efvuiGxyFeBt8mwi08fr1Bkfv7HmLLX9tgJnuR4PhUYlGlhllktQAaI7TzLxnEUWTw9e','7395ab1b1b2cbd2f00099ab74a8ef821361dcafc6b4ae1dbb28de18952dc4ae14eaa51349632b353c6c75fac66e9c5aa8a7ab8e451c7d03bd473ee7f5c893c65'),
	(114,1,'Andrew','Kroft','akroft@jahnelgroup.com','Bb2fSdj52z6Wyunpi2WtW7BoaVhQweCnT1agfKY9H2FQqEHvJB6XxZ4kmasAo4bP9xKJcUtNybObnZsZa1xHSh3rFjospVX9dw1shRhXipQ3C1afmGVgYfVH4jpVtcBN','27f423ba701f7c6c28a8f182564889b2cd2cf6b721641c9192e8ee9f4bb30f2be0c41cc9ea09add7a4cd06f1a2d571693c71dbc0115b9418193aca3f3ea1cc90');

/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;


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
  KEY `EndorsedByUserID` (`EndorsedByUserID`),
  KEY `WorkoutSessionID` (`WorkoutSessionID`),
  CONSTRAINT `workout_ibfk_4` FOREIGN KEY (`EndorsedByUserID`) REFERENCES `Users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workout_ibfk_5` FOREIGN KEY (`WorkoutSessionID`) REFERENCES `WorkoutSession` (`WorkoutSessionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

LOCK TABLES `Workout` WRITE;
/*!40000 ALTER TABLE `Workout` DISABLE KEYS */;

INSERT INTO `Workout` (`WorkoutID`, `WorkoutSessionID`, `WorkoutDescription`, `RequestCoachEndorsementDT`, `CoachEndorsementDT`, `EndorsedByUserID`)
VALUES
	(1,1,'Warmup run - 20:00',NULL,NULL,NULL),
	(2,1,'Erg: 2 x 2k',NULL,NULL,NULL),
	(3,1,'Erg 6 x 400',NULL,NULL,NULL),
	(4,1,'Deadlifts',NULL,NULL,NULL),
	(5,1,'Squats 5x5',NULL,NULL,NULL),
	(6,2,'Warmup run - 20:00',NULL,NULL,NULL),
	(7,2,'Erg: 5 x 1k',NULL,NULL,NULL),
	(54,59,'running',NULL,NULL,NULL),
	(55,59,'New Activity',NULL,NULL,NULL),
	(56,60,'Running on the treadmill',NULL,NULL,NULL),
	(57,60,'Bench Press',NULL,NULL,NULL),
	(58,62,'Bench 425',NULL,NULL,NULL),
	(59,1,'',NULL,NULL,NULL),
	(60,68,'Test Activity',NULL,NULL,NULL);

/*!40000 ALTER TABLE `Workout` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table WorkoutSession
# ------------------------------------------------------------

DROP TABLE IF EXISTS `WorkoutSession`;

CREATE TABLE `WorkoutSession` (
  `WorkoutSessionID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutSessionTypeID` int(11) unsigned NOT NULL,
  `WorkoutSessionDescription` text DEFAULT NULL,
  `UserID` int(11) unsigned NOT NULL,
  `CreateDT` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`WorkoutSessionID`),
  KEY `WorkoutSessionTypeID` (`WorkoutSessionTypeID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `workoutsession_ibfk_3` FOREIGN KEY (`WorkoutSessionTypeID`) REFERENCES `LKWorkoutSessionType` (`WorkoutSessionTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workoutsession_ibfk_4` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;

LOCK TABLES `WorkoutSession` WRITE;
/*!40000 ALTER TABLE `WorkoutSession` DISABLE KEYS */;

INSERT INTO `WorkoutSession` (`WorkoutSessionID`, `WorkoutSessionTypeID`, `WorkoutSessionDescription`, `UserID`, `CreateDT`)
VALUES
	(1,1,'Monday, 11/27 AM Practice',63,'2017-11-26 13:06:52'),
	(2,1,'Tuesday, 11/27 PM Workout',63,'2017-11-26 13:34:00'),
	(58,1,'Insanity Workout',63,'2017-12-12 01:33:22'),
	(59,1,'Katie\'s workout',63,'2017-12-12 02:03:25'),
	(60,1,'Mark\'s workout',63,'2017-12-20 03:50:13'),
	(61,1,'Test workout',63,'2017-12-20 03:52:41'),
	(62,1,'Steven\'s workout',63,'2017-12-20 20:57:35'),
	(63,1,'Test workout',63,'2017-12-30 18:43:02'),
	(64,1,'Test workout',63,'2017-12-30 18:43:08'),
	(65,1,'Test',63,'2017-12-30 18:44:09'),
	(66,1,'Testing',63,'2017-12-30 20:51:57'),
	(67,1,'TEST101',63,'2017-12-30 20:54:37'),
	(68,1,'ARGHHHH',63,'2017-12-30 20:55:21');

/*!40000 ALTER TABLE `WorkoutSession` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table WorkoutSets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `WorkoutSets`;

CREATE TABLE `WorkoutSets` (
  `WorkoutSetID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `WorkoutID` int(11) unsigned NOT NULL,
  `WorkoutSetTypeID` int(11) unsigned NOT NULL,
  `Weight` float DEFAULT NULL,
  `Reps` smallint(6) DEFAULT NULL,
  `ExerciseTime` float DEFAULT NULL,
  `SplitTime` float DEFAULT NULL,
  `SPM` tinyint(3) DEFAULT NULL,
  `RestTime` float DEFAULT NULL,
  `DesiredIntensity` tinyint(3) DEFAULT NULL,
  `DesiredIntensityTypeID` int(11) unsigned DEFAULT NULL,
  `HeartRateID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkoutSetID`),
  KEY `WorkoutSetTypeID` (`WorkoutSetTypeID`),
  KEY `WorkoutID` (`WorkoutID`),
  CONSTRAINT `workoutsets_ibfk_2` FOREIGN KEY (`WorkoutSetTypeID`) REFERENCES `LKWorkoutSetType` (`WorkoutSetTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workoutsets_ibfk_3` FOREIGN KEY (`WorkoutID`) REFERENCES `Workout` (`WorkoutID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

LOCK TABLES `WorkoutSets` WRITE;
/*!40000 ALTER TABLE `WorkoutSets` DISABLE KEYS */;

INSERT INTO `WorkoutSets` (`WorkoutSetID`, `WorkoutID`, `WorkoutSetTypeID`, `Weight`, `Reps`, `ExerciseTime`, `SplitTime`, `SPM`, `RestTime`, `DesiredIntensity`, `DesiredIntensityTypeID`, `HeartRateID`)
VALUES
	(3,1,3,NULL,NULL,1200,NULL,NULL,NULL,2,2,NULL);

/*!40000 ALTER TABLE `WorkoutSets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
