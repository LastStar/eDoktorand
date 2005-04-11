-- MySQL dump 10.9
--
-- Host: gravastar.cz    Database: phdstudy_development
-- ------------------------------------------------------
-- Server version	4.1.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
CREATE TABLE `candidates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `last_name` varchar(50) default NULL,
  `title` varchar(20) default NULL,
  `coridor_id` int(11) default NULL,
  `study_end` date default NULL,
  `university` varchar(100) default NULL,
  `birth_on` date default NULL,
  `birth_number` varchar(11) default NULL,
  `birth_at` varchar(100) default NULL,
  `email` varchar(100) default NULL,
  `street` varchar(100) default NULL,
  `city` varchar(100) default NULL,
  `zip` varchar(10) default NULL,
  `postal_street` varchar(100) default NULL,
  `phone` varchar(50) default NULL,
  `state` varchar(50) default NULL,
  `studied_branch` varchar(200) default NULL,
  `employer` varchar(50) default NULL,
  `employer_address` varchar(50) default NULL,
  `employer_email` varchar(50) default NULL,
  `employer_phone` varchar(50) default NULL,
  `position` varchar(50) default NULL,
  `department_id` int(11) default NULL,
  `language1` int(1) default NULL,
  `language2` int(1) default NULL,
  `study_id` int(11) default NULL,
  `postal_city` varchar(100) default NULL,
  `postal_zip` varchar(10) default NULL,
  `faculty` varchar(100) default NULL,
  `studied_specialization` varchar(100) default NULL,
  `study_theme` varchar(100) default NULL,
  `finished_on` timestamp NULL default NULL,
  `note` text,
  `number` int(4) default NULL,
  `postal_number` int(4) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `last_name` (`last_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `coridors`
--

DROP TABLE IF EXISTS `coridors`;
CREATE TABLE `coridors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `faculty_id` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `faculty_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `faculties`
--

DROP TABLE IF EXISTS `faculties`;
CREATE TABLE `faculties` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
CREATE TABLE `languages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `sessid` text,
  `data` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `studies`
--

DROP TABLE IF EXISTS `studies`;
CREATE TABLE `studies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) character set latin1 collate latin1_bin default NULL,
  `password` varchar(40) character set latin1 collate latin1_bin default NULL,
  PRIMARY KEY  (`id`),
  KEY `login` (`login`),
  KEY `password` (`password`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

