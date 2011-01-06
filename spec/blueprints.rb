# encoding:utf-8
require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.firstname {Faker::Name.first_name}
Sham.lastname {Faker::Name.last_name}
Sham.name {|index| "Name #{index}"}
Sham.short_name {|index| "NM#{index}"}
Sham.birth_on {Date.civil(1980, rand(11) + 1, rand(27) + 1)}
Sham.city {Faker::Address.city}
Sham.street {Faker::Address.street_name}
Sham.zip {Faker::Address.zip_code}
Sham.email {Faker::Internet.email}
Sham.university {"University of #{Faker::Address.city}"}
Sham.state {Faker::Address.us_state}
Sham.label {|index| "Label #{index}"}
Sham.code {|index| "CD#{index}"}
Sham.login {Faker::Internet.user_name}
Sham.title {|index| "Title ##{index}"}

Faculty.blueprint do
  name {"Faculty"}
  short_name {"FAC"}
end

FacultyEmployment.blueprint do
  faculty
end

Person.blueprint do
  firstname
  lastname
end

User.blueprint do
  login
  person
end

Role.blueprint do
  name {'admin'}
end

FacultySecretary.blueprint do
  firstname
  lastname
  faculty_employment
end

Candidate.blueprint do
  firstname 'Karel'
  lastname 'Marel'
  birth_at '1980-01-01'
  email 'karel@marel.cz'
  phone '+420777888999'
  street 'Long'
  number '2'
  city 'Prague'
  zip '10000'
  state 'CZ'
  university 'CZU'
  faculty 'FAAPPZ'
  studied_branch 'Agro'
  birth_number '7604242624'
  department
  language1_id 1
  language2_id 2
  sex 'M'
  foreign_pay false

end

Candidate.blueprint(:finished) do
  finished_on {Time.now}
end

Candidate.blueprint(:ready) do
  finished_on {Time.now}
  ready_on {Time.now}
end

Candidate.blueprint(:invited) do
  finished_on {Time.now}
  ready_on {Time.now}
  invited_on {Time.now}
end

Candidate.blueprint(:admitted) do
  finished_on {Time.now}
  ready_on {Time.now}
  invited_on {Time.now}
  admited_on {Time.now}
end


LanguageSubject.blueprint do
  subject
  specialization
end

Title.blueprint do
  label {"Ing."}
  prefix {true}
end

Title.blueprint(:title_after) do
  label {"Ph.D."}
end

Specialization.blueprint do
  name 'Specialization'
  code 'SPE'
  msmt_code 'MSPE'
  faculty
  accredited true
  study_length 4
  program
end

Program.blueprint do
  label 'Program'
  code 'PRG'
end

Subject.blueprint do
  label
  code
end

Student.blueprint do
  firstname
  lastname
end

Index.blueprint do
  enrolled_on TermsCalculator.this_year_start.to_date
  student
  study
  tutor
  specialization
  department
  payment_id 1
  account_number '2303308001'
  account_number_prefix '35'
  account_bank_number '5500'
  study_form_changed_on '2010-01-02'
end

Study.blueprint do
  name "prezenční"
  name_en "full time"
  code 'D'
end

Tutor.blueprint do
  firstname
  lastname
end

Department.blueprint do
  name {"Department"}
  short_name {"DEP"}
  faculty
end

StudyInterrupt.blueprint do
  index
  start_on {Time.current}
  duration {8}
end

ExtraScholarship.blueprint do
  amount {1}
  commission_head {'4444'}
  commission_body {'55555'}
  commission_tail {'4444'}
end

DisertTheme.blueprint do
  index
  title
  finishing_to {6}
end

StudyPlan.blueprint do
  index
end

Leader.blueprint do
  firstname
  lastname
  leadership
end

Leadership.blueprint do
  department
end

Dean.blueprint do
  firstname
  lastname
  deanship
end

Deanship.blueprint do
  faculty
end

Permission.blueprint do
  name {'account/login'}
end

TutorStatement.blueprint do
  person {Tutor.make}
end

LeaderStatement.blueprint do
  person {Leader.make}
end

DeanStatement.blueprint do
  person {Dean.make}
end
