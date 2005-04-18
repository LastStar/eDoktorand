
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
  city varchar(100),
  zip varchar(10),
  postal_street varchar(100),
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
  postal_city varchar(100),
  postal_zip varchar(10),
  faculty varchar(100),
  studied_specialization varchar(100),
  study_theme varchar(100),
  finished_on timestamp,
  created_on timestamp,
  admited_on timestamp,
  note text,
  number integer,
  postal_number integer,
  student_id integer
);

--
-- Table structure for table coridors
--

DROP TABLE coridors;
CREATE TABLE coridors (
  id integer primary key,
  name varchar(50),
  faculty_id varchar(50)
);

--
-- Table structure for table departments
--

DROP TABLE departments;
CREATE TABLE departments (
  id integer primary key,
  name varchar(50),
  faculty_id integer
);

--
-- Table structure for table faculties
--

DROP TABLE faculties;
CREATE TABLE faculties (
  id integer primary key,
  name varchar(50)
);

--
-- Table structure for table languages
--

DROP TABLE languages;
CREATE TABLE languages (
  id integer primary key,
  name varchar(50)
);


--
-- Table structure for table Documents
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
  birth_number varchar,
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
  year integer,
  study_id integer,
  student_id integer,
  tutorship_id integer
);

--
-- Table structure for table study plans statuses
--

DROP TABLE study_plans_statuses;
CREATE TABLE study_plans_statuses (
  id integer primary key,
  name varchar(100)
);

--
-- Table structure for table study plans
--

DROP TABLE study_plans;
CREATE TABLE study_plans (
  id integer primary key,
  index_id integer,
  actual integer,
  status_id integer
);

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
  name varchar(20)
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
  name varchar(20)
);

--
-- Table structure for table tutorships
--

DROP TABLE tutorships;
CREATE TABLE tutorships (
  id integer primary key,
  department_id integer,
  tutor_id integer,
  corridor_id integer
);
--
-- Table structure for table titles
--

DROP TABLE titles;
CREATE TABLE titles (
  id integer primary key,
  name varchar(100),
  before integer
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


--
-- Table structure for table users
--

DROP TABLE users;
CREATE TABLE users (
  id integer primary key,
  login varchar(80),
  password varchar(40)
);

