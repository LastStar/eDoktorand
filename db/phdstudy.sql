
--
-- Table structure for table candidates
--

DROP TABLE IF EXISTS candidates;
CREATE TABLE candidates (
  id integer primary key auto_increment,
  firstname varchar(50),
  lastname varchar(50),
  title_before_id integer,
  title_after_id integer,
  coridor_id integer,
  study_end date,
  university varchar(100),
  birth_on date,
  birth_number varchar(11),
  birth_at varchar(100),
  email varchar(100),
  street varchar(100),
  number integer,
  city varchar(100),
  zip varchar(10),
  postal_street varchar(100),
  postal_number integer,
  postal_city varchar(100),
  postal_zip varchar(10),
  phone varchar(50),
  state varchar(50),
  studied_branch varchar(200),
  employer varchar(50),
  employer_address varchar(50),
  employer_email varchar(50),
  employer_phone varchar(50),
  position varchar(50),
  department_id integer,
  language1 integer,
  language2 integer,
  study_id integer,
  faculty varchar(100),
  studied_specialization varchar(100),
  study_theme varchar(100),
  note text,
  created_on datetime,
  updated_on datetime,
  finished_on datetime default 0,
  ready_on datetime default 0,
  admited_on datetime default 0, 
  invited_on datetime default 0,
  rejected_on datetime default 0,
  enrolled_on datetime default 0,
  student_id integer,
  tutor_id integer
);

--
-- Table structure for table coridors
-- should be renamed to corridors
--

DROP TABLE IF EXISTS coridors;
CREATE TABLE coridors (
  id integer primary key auto_increment,
  name varchar(1024),
  name_english varchar(1024),
  code varchar(16),
  faculty_id integer
);


--
-- table stucture for corridors_subjects
--

DROP TABLE IF EXISTS coridor_subjects;
CREATE TABLE coridor_subjects (
  id integer primary key auto_increment,
  coridor_id integer,
  subject_id integer,
  type varchar(32)
);

--
-- Table structure for table departments
--

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
  id integer primary key auto_increment,
  name varchar(256),
  name_english varchar(256),
  short_name varchar(8),
  faculty_id integer
);

--
-- Table structure for table faculties
--

DROP TABLE IF EXISTS faculties;
CREATE TABLE faculties (
  id integer primary key auto_increment,
  name varchar(256),
  name_english varchar(256),
  short_name varchar(8),
  ldap_context varchar(256)
);

--
-- Table structure for table languages
-- just stub for admit form
--

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
  id integer primary key auto_increment,
  name varchar(50)
);

--
-- Table structure for table exam_terms
--

DROP TABLE IF EXISTS exam_terms;
CREATE TABLE exam_terms (
  id integer primary key auto_increment,
	coridor_id integer,
	date date,
	start_time varchar(5),
	room varchar(20),
	chairman_id integer,	
	first_examinator varchar(100),
	second_examinator varchar(100),
	third_examinator varchar(100),
	fourth_examinator varchar(100),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table admittances
--

--DROP TABLE IF EXISTS admittances;
--CREATE TABLE admittances (
--  id integer primary key auto_increment,
--	skilled_exam varchar(100),
--	first_language integer,
--	second_language integer,
--	passed integer,
--	rank integer,
--	admit integer,
--	recomended_tutor varchar(100),
--	notes text,
--	dean_conclusion_admit integer,
--	candidate_id integer
--);

--
-- Table structure for table documents
--

DROP TABLE IF EXISTS documents;
CREATE TABLE documents (
  id integer primary key auto_increment,
  name varchar(100),
  path varchar(100),
  faculty_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table studies
--

DROP TABLE IF EXISTS studies;
CREATE TABLE studies (
  id integer primary key auto_increment,
  name varchar(50)
);

--
-- Table structure for table people
--

DROP TABLE IF EXISTS people;
CREATE TABLE people (
  id integer primary key auto_increment,
  uic integer,
  firstname varchar(101),
  birthname varchar(100),
  lastname varchar(100),
  birth_on date,
  birth_number varchar(10),
  state varchar(100),
  birth_at varchar(100),
  type varchar(20),
  title_before_id integer,
  title_after_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table indices
--

DROP TABLE IF EXISTS indices;
CREATE TABLE indices (
  id integer primary key auto_increment,
  student_id integer,
  department_id integer,
  coridor_id integer,
  disert_theme_id integer,
  tutor_id integer,
  study_id integer,
  finished_on datetime default 0,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table study plans
--

DROP TABLE IF EXISTS study_plans;
CREATE TABLE study_plans (
  id integer primary key auto_increment,
  index_id integer,
  finishing_to integer,
  admited_on datetime default 0,
  last_atested_on default 0,
  canceled_on datetime default 0,
  approved_on datetime default 0,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table plan_subjects
--

DROP TABLE IF EXISTS plan_subjects;
CREATE TABLE plan_subjects (
  id integer primary key auto_increment,
  study_plan_id integer,
  subject_id integer,
  finishing_on integer,
  finished_on datetime default 0,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table Subject
--

DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects (
  id integer primary key auto_increment,
  label varchar(1024),
  code varchar(7),
  type varchar(32),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table Departments_Subjects
--

DROP TABLE IF EXISTS departments_subjects;
CREATE TABLE departments_subjects (
  department_id integer,
  subject_id integer
);


-- 
-- Table structure for relationship externalSubject_detail
--

DROP TABLE IF EXISTS external_subject_details;
CREATE TABLE external_subject_details (
  id integer primary key auto_increment,
  external_subject_id integer,
  university varchar(1024),
  person varchar (256),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table exams
--

DROP TABLE IF EXISTS exams;
CREATE TABLE exams (
  id integer primary key auto_increment,
  index_id integer,
  first_examinator_id integer,
  second_examinator_id integer,
  result integer,
  questions text,
  subject_id integer,
  created_by integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for probation term
--

DROP TABLE IF EXISTS probation_terms;
CREATE TABLE probation_terms (
  id integer primary key auto_increment,
  subject_id integer,
  first_examinator_id integer,
  second_examinator_id integer,
	date date,
	start_time varchar(5),
	room varchar(20),
  max_students integer,
  note text,
  created_by integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for probation term student
--

DROP TABLE IF EXISTS probation_terms_students;
CREATE TABLE probation_terms_students (
  probation_term_id integer,
  student_id integer
);

--
-- Table structure for table interupts
--

DROP TABLE IF EXISTS interupts;
CREATE TABLE interupts (
  id integer primary key auto_increment,
  index_id integer,
  note varchar(100),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table approvements
-- aproovements are related to study_plans, disert_themes and interupts
--

DROP TABLE IF EXISTS approvements;
CREATE TABLE approvements (
  id integer primary key auto_increment,
  type varchar(30),
  document_id integer,
  tutor_statement_id integer,
  leader_statement_id integer,
  dean_statement_id integer,
  board_statement_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table deliverance
--

DROP TABLE IF EXISTS statements;
CREATE TABLE statements (
  id integer primary key auto_increment,
  note varchar(100),
  result integer,
  person_id integer,
  created_on datetime,
  updated_on datetime
);



--
-- Table structure for table tutorships
--

DROP TABLE IF EXISTS tutorships;
CREATE TABLE tutorships (
  id integer primary key auto_increment,
  department_id integer,
  tutor_id integer,
  coridor_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table leaderships
--

DROP TABLE IF EXISTS leaderships;
CREATE TABLE leaderships (
  id integer primary key auto_increment,
  department_id integer,
  leader_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table deanships
--

DROP TABLE IF EXISTS deanships;
CREATE TABLE deanships (
  id integer primary key auto_increment,
  faculty_id integer,
  dean_id integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table employments
--

DROP TABLE IF EXISTS employments;
CREATE TABLE employments (
  id integer primary key auto_increment,
  unit_id integer,
  person_id integer,
  created_on datetime,
  updated_on datetime
);


--
-- Table structure for table disert_themes
--

DROP TABLE IF EXISTS disert_themes;
CREATE TABLE disert_themes (
  id integer primary key auto_increment,
  title varchar(100),
  index_id integer,
  methodology_summary text, 
  methodology_summary_added_on datetime default 0,
  methodology_added_on datetime default 0,
  finishing_to integer,
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table atestation_details
--

DROP TABLE IF EXISTS atestation_details;
CREATE TABLE atestation_details (
  id integer primary key auto_increment,
  atestation_id integer,
  detail text, 
  created_on datetime,
  updated_on datetime
);

-- deprecated in favor of simple methodology file in disert
-- Table structure for table methodologies
--

-- DROP TABLE IF EXISTS methodologies;
-- CREATE TABLE methodologies (
--   id integer primary key auto_increment,
--   text varchar(255),
--   disert_theme_id integer
-- );

-- deprecated in favor of method driven checks
-- Table structure for table study plans statuses
--

-- DROP TABLE IF EXISTS study_plans_statuses;
-- CREATE TABLE study_plans_statuses (
  -- id integer primary key,
  -- name varchar(100)
-- );

----------------------------------------
-- security part of the application
----------------------------------------

--
-- Table structure for table users
--

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id integer primary key auto_increment,
  login varchar(80),
  password varchar(40),
  person_id integer,
  created_on datetime,
  updated_on datetime
);


--
-- Table structure for table roles
--

DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
  id integer primary key auto_increment,
  name varchar(20),
  info varchar(100),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table permissions
--
DROP TABLE IF EXISTS permissions;
CREATE TABLE permissions (
  id integer primary key auto_increment,
  name varchar(100),
  info varchar(100),
  created_on datetime,
  updated_on datetime
);

--
-- Table structure for table roles_users
--

DROP TABLE IF EXISTS roles_users;
CREATE TABLE roles_users (
  user_id integer,
  role_id integer 
);


--
-- Table structure for table permissions_roles
--

DROP TABLE IF EXISTS permissions_roles;
CREATE TABLE permissions_roles (
  role_id integer,
  permission_id integer 
);

-----------------------------------------
-- folowing structures are related to DWH
-----------------------------------------

--
-- Table structure for table addresses
--

DROP TABLE IF EXISTS addresses;
CREATE TABLE addresses (
  id integer primary key auto_increment,
  street varchar(100),
  desc_number varchar(20),
  orient_number varchar(20),
  city varchar(20),
  zip varchar(20),
  state varchar(20),
  address_type_id integer,
  student_id integer
);


--
-- Table structure for table address types
--

DROP TABLE IF EXISTS address_types;
CREATE TABLE address_types (
  id integer primary key auto_increment,
  label varchar(20)
);

--
-- Table structure for table contacts
--

DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
  id integer primary key auto_increment,
  name varchar(20),
  contact_type_id integer,
  person_id integer
);

--
-- Table structure for table contacts
--

DROP TABLE IF EXISTS contact_types;
CREATE TABLE contact_types (
  id integer primary key auto_increment,
  label varchar(20)
);

--
-- Table structure for table titles
--

DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
  id integer primary key auto_increment,
  label varchar(100),
  prefix integer
);


--
-- Table structure for table sessions
--

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  id integer primary key auto_increment,
  sessid text,
  data text
);


