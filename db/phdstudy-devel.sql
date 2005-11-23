-- MySQL dump 10.9
--
-- Host: localhost    Database: phdstudy-devel
-- ------------------------------------------------------
-- Server version	4.1.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `address_types`
--

CREATE TABLE `address_types` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL auto_increment,
  `street` varchar(100) default NULL,
  `desc_number` varchar(20) default NULL,
  `orient_number` varchar(20) default NULL,
  `city` varchar(20) default NULL,
  `zip` varchar(20) default NULL,
  `state` varchar(20) default NULL,
  `address_type_id` int(11) default NULL,
  `student_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `approvements`
--

CREATE TABLE `approvements` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(30) default NULL,
  `document_id` int(11) default NULL,
  `tutor_statement_id` int(11) default NULL,
  `leader_statement_id` int(11) default NULL,
  `dean_statement_id` int(11) default NULL,
  `board_statement_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `atestation_details`
--

CREATE TABLE `atestation_details` (
  `id` int(11) NOT NULL auto_increment,
  `atestation_term_id` int(11) default NULL,
  `detail` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `study_plan_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(50) default NULL,
  `lastname` varchar(50) default NULL,
  `title_before_id` int(11) default NULL,
  `title_after_id` int(11) default NULL,
  `coridor_id` int(11) default NULL,
  `study_end` date default NULL,
  `university` varchar(100) default NULL,
  `birth_on` date default NULL,
  `birth_number` varchar(11) default NULL,
  `birth_at` varchar(100) default NULL,
  `email` varchar(100) default NULL,
  `street` varchar(100) default NULL,
  `number` int(11) default NULL,
  `city` varchar(100) default NULL,
  `zip` varchar(10) default NULL,
  `postal_street` varchar(100) default NULL,
  `postal_number` int(11) default NULL,
  `postal_city` varchar(100) default NULL,
  `postal_zip` varchar(10) default NULL,
  `phone` varchar(50) default NULL,
  `state` varchar(50) default NULL,
  `studied_branch` varchar(200) default NULL,
  `employer` varchar(50) default NULL,
  `employer_address` varchar(50) default NULL,
  `employer_email` varchar(50) default NULL,
  `employer_phone` varchar(50) default NULL,
  `position` varchar(50) default NULL,
  `department_id` int(11) default NULL,
  `language1` int(11) default NULL,
  `language2` int(11) default NULL,
  `study_id` int(11) default NULL,
  `faculty` varchar(100) default NULL,
  `studied_specialization` varchar(100) default NULL,
  `study_theme` varchar(100) default NULL,
  `note` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `finished_on` datetime default '0000-00-00 00:00:00',
  `ready_on` datetime default '0000-00-00 00:00:00',
  `admited_on` datetime default '0000-00-00 00:00:00',
  `invited_on` datetime default '0000-00-00 00:00:00',
  `rejected_on` datetime default '0000-00-00 00:00:00',
  `enrolled_on` datetime default '0000-00-00 00:00:00',
  `student_id` int(11) default NULL,
  `tutor_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `contact_types`
--

CREATE TABLE `contact_types` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) default NULL,
  `contact_type_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `coridor_subjects`
--

CREATE TABLE `coridor_subjects` (
  `id` int(11) NOT NULL auto_increment,
  `coridor_id` int(11) default NULL,
  `subject_id` int(11) default NULL,
  `type` varchar(32) default NULL,
  `requisite_on` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `coridors`
--

CREATE TABLE `coridors` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `name_english` text,
  `code` varchar(16) default NULL,
  `faculty_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `deanships`
--

CREATE TABLE `deanships` (
  `id` int(11) NOT NULL auto_increment,
  `faculty_id` int(11) default NULL,
  `dean_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `name_english` text,
  `short_name` varchar(8) default NULL,
  `faculty_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `departments_subjects`
--

CREATE TABLE `departments_subjects` (
  `department_id` int(11) default NULL,
  `subject_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `disert_themes`
--

CREATE TABLE `disert_themes` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(100) default NULL,
  `index_id` int(11) default NULL,
  `methodology_added_on` datetime default '0000-00-00 00:00:00',
  `finishing_to` int(11) default NULL,
  `created_on` datetime default '0000-00-00 00:00:00',
  `updated_on` datetime default '0000-00-00 00:00:00',
  `methodology_summary` text,
  `approved_on` datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `path` varchar(100) default NULL,
  `faculty_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `employments`
--

CREATE TABLE `employments` (
  `id` int(11) NOT NULL auto_increment,
  `unit_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `exam_terms`
--

CREATE TABLE `exam_terms` (
  `id` int(11) NOT NULL auto_increment,
  `coridor_id` int(11) default NULL,
  `date` date default NULL,
  `start_time` varchar(5) default NULL,
  `room` varchar(20) default NULL,
  `chairman_id` int(11) default NULL,
  `first_examinator` varchar(100) default NULL,
  `second_examinator` varchar(100) default NULL,
  `third_examinator` varchar(100) default NULL,
  `fourth_examinator` varchar(100) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `id` int(11) NOT NULL auto_increment,
  `index_id` int(11) default NULL,
  `first_examinator_id` int(11) default NULL,
  `second_examinator_id` int(11) default NULL,
  `result` int(11) default NULL,
  `questions` text,
  `subject_id` int(11) default NULL,
  `created_by` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created_by_id` int(11) default NULL,
  `updated_by_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `external_subject_details`
--

CREATE TABLE `external_subject_details` (
  `id` int(11) NOT NULL auto_increment,
  `external_subject_id` int(11) default NULL,
  `university` text,
  `person` text,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `faculties`
--

CREATE TABLE `faculties` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `name_english` text,
  `short_name` varchar(8) default NULL,
  `ldap_context` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `indices`
--

CREATE TABLE `indices` (
  `id` int(11) NOT NULL auto_increment,
  `student_id` int(11) default NULL,
  `department_id` int(11) default NULL,
  `coridor_id` int(11) default NULL,
  `tutor_id` int(11) default NULL,
  `study_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `finished_on` timestamp NULL default '0000-00-00 00:00:00',
  `created_by_id` int(11) default NULL,
  `update_by_id` int(11) default NULL,
  `payment_id` int(11) default NULL,
  `enrolled_on` timestamp NULL default NULL,
  `account_number_prefix` varchar(5) default NULL ,
  `account_number` varchar(10) default NULL,
  `account_bank_number` varchar(4),
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;


--
-- Table structure for table `scholarships`
--

CREATE TABLE `scholarships` (
  `id` int(11) NOT NULL auto_increment,
  `index_id` int(11) default NULL,
  `amount` float,
  `commission_head` int(4) default null,
  `commission_body` int(6) default null,
  `commission_tail` int(4) default null,
  `payed_on` timestamp NOT NULL default  '0000-00-00 00:00:00',
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created_by_id` int(11) default NULL,
  `update_by_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `interupts`
--

CREATE TABLE `interupts` (
  `id` int(11) NOT NULL auto_increment,
  `index_id` int(11) default NULL,
  `note` varchar(100) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `leaderships`
--

CREATE TABLE `leaderships` (
  `id` int(11) NOT NULL auto_increment,
  `department_id` int(11) default NULL,
  `leader_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `people`
--

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(101) default NULL,
  `lastname` varchar(100) default NULL,
  `birth_on` date default NULL,
  `birth_number` varchar(10) default NULL,
  `state` varchar(100) default NULL,
  `birth_at` varchar(100) default NULL,
  `type` varchar(20) default NULL,
  `title_before_id` int(11) default NULL,
  `title_after_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `uic` int(11) default NULL,
  `birthname` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `info` varchar(100) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `permissions_roles`
--

CREATE TABLE `permissions_roles` (
  `role_id` int(11) default NULL,
  `permission_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `plan_subjects`
--

CREATE TABLE `plan_subjects` (
  `id` int(11) NOT NULL auto_increment,
  `study_plan_id` int(11) default NULL,
  `subject_id` int(11) default NULL,
  `finishing_on` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `finished_on` datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `probation_terms`
--

CREATE TABLE `probation_terms` (
  `id` int(11) NOT NULL auto_increment,
  `subject_id` int(11) default NULL,
  `first_examinator_id` int(11) default NULL,
  `second_examinator_id` int(11) default NULL,
  `date` date default NULL,
  `start_time` varchar(5) default NULL,
  `room` varchar(20) default NULL,
  `max_students` int(11) default NULL,
  `note` text,
  `created_by` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `probation_terms_students`
--

CREATE TABLE `probation_terms_students` (
  `probation_term_id` int(11) default NULL,
  `student_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) default NULL,
  `info` varchar(100) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `roles_users`
--

CREATE TABLE `roles_users` (
  `user_id` int(11) default NULL,
  `role_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `sessid` text,
  `data` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `statements`
--

CREATE TABLE `statements` (
  `id` int(11) NOT NULL auto_increment,
  `note` varchar(100) default NULL,
  `result` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `studies`
--

CREATE TABLE `studies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `study_plans`
--

CREATE TABLE `study_plans` (
  `id` int(11) NOT NULL auto_increment,
  `index_id` int(11) default NULL,
  `actual` int(11) default NULL,
  `finishing_to` int(11) default NULL,
  `admited_on` datetime default '0000-00-00 00:00:00',
  `canceled_on` datetime default '0000-00-00 00:00:00',
  `approved_on` datetime default '0000-00-00 00:00:00',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `last_atested_on` datetime default '0000-00-00 00:00:00',
  `created_by_id` int(11) default NULL,
  `updated_by_id` int(11) default NULL,
  `final_areas` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL auto_increment,
  `label` text,
  `code` varchar(7) default NULL,
  `type` varchar(32) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `titles`
--

CREATE TABLE `titles` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(100) default NULL,
  `prefix` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `tutorships`
--

CREATE TABLE `tutorships` (
  `id` int(11) NOT NULL auto_increment,
  `department_id` int(11) default NULL,
  `tutor_id` int(11) default NULL,
  `coridor_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  `person_id` int(11) default NULL,
  `created_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=UTF8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

