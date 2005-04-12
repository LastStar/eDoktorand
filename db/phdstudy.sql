
--
-- Table structure for table candidates
--

DROP TABLE candidates;
CREATE TABLE candidates (
  id integer primary key,
  name varchar(50),
  last_name varchar(50),
  title varchar(20),
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
  note text,
  number integer,
  postal_number integer,
  status integer
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
-- Table structure for table sessions
--

DROP TABLE sessions;
CREATE TABLE sessions (
  id integer primary key,
  sessid text,
  data text
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
-- Table structure for table users
--

DROP TABLE users;
CREATE TABLE users (
  id integer primary key,
  login varchar(80),
  password varchar(40)
);


