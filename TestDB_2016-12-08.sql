# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.6.33)
# Database: TestDB
# Generation Time: 2016-12-08 17:43:46 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table events
# ------------------------------------------------------------

DROP TABLE IF EXISTS `events`;

CREATE TABLE `events` (
  `sensor_id` int(11) NOT NULL,
  `event_type` int(11) NOT NULL,
  `value_info` int(11) NOT NULL,
  `time_info` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `time_info` (`time_info`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;

INSERT INTO `events` (`sensor_id`, `event_type`, `value_info`, `time_info`)
VALUES
	(2,4,-42,'2014-02-13 03:19:57'),
	(2,2,5,'2014-02-13 12:42:00'),
	(3,2,7,'2014-02-13 12:54:39'),
	(2,4,-42,'2014-02-13 13:19:57'),
	(2,3,54,'2014-02-13 13:32:36'),
	(2,2,2,'2014-02-13 14:48:30');

/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

/*query output*/
Select e.`sensor_id`,e.`event_type`,e.`value_info`
From events e
group by e.`sensor_id`,e.`event_type`,e.`value_info`,e.`time_info`
order by e.`time_info` asc;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
