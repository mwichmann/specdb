-- MySQL dump 10.11
--
-- Host: localhost    Database: lsb
-- ------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `TestSuite`
--

DROP TABLE IF EXISTS `TestSuite`;
CREATE TABLE `TestSuite` (
  `TSid` int(10) unsigned NOT NULL auto_increment,
  `TSname` varchar(255) NOT NULL default '',
  `TSfullname` varchar(255) NOT NULL default '',
  `TSvendor` varchar(255) NOT NULL default '',
  `TSstatus` enum('Yes','No','Unknown') NOT NULL default 'Unknown',
  `TSpartof` varchar(255) NOT NULL default '',
  `TSversion` varchar(255) NOT NULL default '',
  `TSappearedin` varchar(255) NOT NULL default '',
  `TSwithdrawnin` varchar(255) default NULL,
  PRIMARY KEY  (`TSid`),
  KEY `TSid` (`TSid`,`TSname`,`TSversion`),
  KEY `TSappearedin` (`TSappearedin`,`TSwithdrawnin`),
  KEY `TSwithdrawnin` (`TSwithdrawnin`),
  KEY `TSname` (`TSname`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-02-12 10:40:28
