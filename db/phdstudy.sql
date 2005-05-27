
--
-- Table structure for table candidates
--

DROP TABLE candidates;
CREATE TABLE candidates (
  id integer primary key,
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
  created_on timestamp,
  finished_on timestamp,
  ready_on timestamp,
  admited_on timestamp,  
	invited_on timestamp,
	enrolled_on timestamp,
  student_id integer,
  tutor_id integer
);

--
-- Table structure for table coridors
-- should be renamed to corridors
--

DROP TABLE coridors;
CREATE TABLE coridors (
  id integer primary key,
  name varchar(50),
  faculty_id integer
);


--
-- table stucture for corridors_subjects
--

DROP TABLE coridor_subjects;
CREATE TABLE coridor_subjects (
  id integer primary key,
  coridor_id integer,
  subject_id integer,
  type varchar(32)
);

--
-- Table structure for table departments
--

DROP TABLE departments;
CREATE TABLE departments (
  id integer primary key,
  name varchar(256),
  faculty_id integer
);

--
-- Table structure for table faculties
--

DROP TABLE faculties;
CREATE TABLE faculties (
  id integer primary key,
  name varchar(256)
);

--
-- Table structure for table languages
-- just stub for admit form
--

DROP TABLE languages;
CREATE TABLE languages (
  id integer primary key,
  name varchar(50)
);

--
-- Table structure for table exam_terms
--

DROP TABLE exam_terms;
CREATE TABLE exam_terms (
  id integer primary key,
	coridor_id integer,
	date date,
	start_time varchar(5),
	room varchar(20),
	chairman_id integer,	
  created_on timestamp,
  updated_on timestamp,
	first_examinator varchar(100),
	second_examinator varchar(100),
	third_examinator varchar(100),
	fourth_examinator varchar(100)
);

--
-- Table structure for table admittances
--

--DROP TABLE admittances;
--CREATE TABLE admittances (
--  id integer primary key,
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

DROP TABLE documents;
CREATE TABLE documents (
  id integer primary key,
  name varchar(100),
  path varchar(100),
  faculty_id integer
);

--
-- Table structure for table studies
--

DROP TABLE studies;
CREATE TABLE studies (
  id integer primary key,
  name varchar(50)
);

--
-- Table structure for table people
--

DROP TABLE people;
CREATE TABLE people (
  id integer primary key,
  firstname varchar(101),
  lastname varchar(100),
  birth_on date,
  birth_number varchar(10),
  state varchar(100),
  birth_at varchar(100),
  type varchar(20),
  title_before_id integer,
  title_after_id integer
);

--
-- Table structure for table indexes
--

DROP TABLE indexes;
CREATE TABLE indexes (
  id integer primary key,
  -- year integer, -- should be computed in class?
  study_plan_id integer,
  student_id integer,
  department_id integer,
  coridor_id integer,
  disert_theme_id integer,
  tutor_id integer,
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table study plans
--

DROP TABLE study_plans;
CREATE TABLE study_plans (
  id integer primary key,
  index_id integer,
  actual integer,
  created_on timestamp,
  updated_on timestamp,
  admited_on timestamp,
  canceled_on timestamp,
  approved_on timestamp
  -- status_id integer -- deprecated in favor of method driven checks
);

--
-- Table structure for table plan_subjects
--

DROP TABLE plan_subjects;
CREATE TABLE plan_subjects (
  id integer primary key,
  study_plan_id integer,
  subject_id integer,
  finishing_to timestamp,
  created_on timestamp,
  updated_on timestamp
);


--
-- Table structure for table Subject
--

DROP TABLE subjects;
CREATE TABLE subjects (
  id integer primary key,
  label varchar(1024),
  code varchar(7),
  type varchar(32),
  created_on timestamp,
  updated_on timestamp
);


-- 
-- Table structure for relationship externalSubject_detail
--

DROP TABLE external_subject_details;
CREATE TABLE external_subject_details (
  id integer primary key,
  subject_id integer,
  university varchar(1024),
  person varchar (256),
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table exam
--

DROP TABLE exam;
CREATE TABLE exam (
  id integer primary key,
  index_id integer,
  first_examinator_id integer,
  second_examinator_id integer,
  result integer,
  questions varchar(100),
  subject_id integer,
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table interupts
--

DROP TABLE interupts;
CREATE TABLE interupts (
  id integer primary key,
  index_id integer,
  note varchar(100),
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table approvements
-- aproovements are related to study_plans, disert_themes and interupts
--

DROP TABLE approvements;
CREATE TABLE approvements (
  id integer primary key,
  type varchar(30),
  document_id integer,
  tutor_statement_id integer,
  leader_statement_id integer,
  dean_statement_id integer,
  board_statement_id integer,
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table deliverance
--

DROP TABLE statement;
CREATE TABLE statement (
  id integer primary key,
  note varchar(100),
  result integer,
  created_on timestamp,
  updated_on timestamp
);



--
-- Table structure for table tutorships
--

DROP TABLE tutorships;
CREATE TABLE tutorships (
  id integer primary key,
  department_id integer,
  tutor_id integer,
  coridor_id integer,
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table leaderships
--

DROP TABLE leaderships;
CREATE TABLE leaderships (
  id integer primary key,
  department_id integer,
  employee_id integer,
  created_on timestamp,
  updated_on timestamp
);

--
-- Table structure for table deanships
--

DROP TABLE deanships;
CREATE TABLE deanships (
  id integer primary key,
  faculty_id integer,
  employee_id integer,
  created_on timestamp,
  updated_on timestamp
);


--
-- Table structure for table disert_themes
--

DROP TABLE disert_themes;
CREATE TABLE disert_themes (
  id integer primary key,
  title varchar(100),
  index_id integer,
  methodology_file varchar(30),
  finishing_on timestamp,
  created_on timestamp,
  updated_on timestamp
);

-- deprecated in favor of simple methodology file in disert
-- Table structure for table methodologies
--

-- DROP TABLE methodologies;
-- CREATE TABLE methodologies (
--   id integer primary key,
--   text varchar(255),
--   disert_theme_id integer
-- );

-- deprecated in favor of method driven checks
-- Table structure for table study plans statuses
--

-- DROP TABLE study_plans_statuses;
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

DROP TABLE users;
CREATE TABLE users (
  id integer primary key,
  login varchar(80),
  password varchar(40),
  person_id integer
);


--
-- Table structure for table roles
--

DROP TABLE roles;
CREATE TABLE roles (
  id integer primary key,
  name varchar(20),
  info varchar(100)
);

--
-- Table structure for table permissions
--
DROP TABLE permissions;
CREATE TABLE permissions (
  id integer primary key,
  name varchar(20),
  info varchar(100)
);

--
-- Table structure for table roles_users
--

DROP TABLE roles_users;
CREATE TABLE roles_users (
  user_id integer,
  role_id integer 
);


--
-- Table structure for table permissions_roles
--

DROP TABLE permissions_roles;
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

DROP TABLE addresses;
CREATE TABLE addresses (
  id integer primary key,
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

DROP TABLE address_types;
CREATE TABLE address_types (
  id integer primary key,
  label varchar(20)
);

--
-- Table structure for table contacts
--

DROP TABLE contacts;
CREATE TABLE contacts (
  id integer primary key,
  name varchar(20),
  contact_type_id integer,
  person_id integer
);

--
-- Table structure for table contacts
--

DROP TABLE contact_types;
CREATE TABLE contact_types (
  id integer primary key,
  label varchar(20)
);

--
-- Table structure for table titles
--

DROP TABLE titles;
CREATE TABLE titles (
  id integer primary key,
  label varchar(100),
  prefix integer
);


--
-- Table structure for table sessions
--

DROP TABLE sessions;
CREATE TABLE sessions (
  id integer primary key,
  sessid text,
  data text
);


