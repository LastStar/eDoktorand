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

Faculty.blueprint do
  name {Sham.name}
  short_name {Sham.short_name}
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
  firstname
  lastname
  title_before
  title_after
  birth_on
  birth_at {Sham.city}
  university
  email
  street
  number {rand(100)}
  city
  zip
  state
  faculty {"Science faculty of #{university}"}
  studied_branch {"Branch of science"}
  birth_number {"7604242624"}
  language1 {Subject.make}
  language2 {Subject.make}
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
  name {Sham.name}
  faculty
  accredited {true}
end

Subject.blueprint do
  label
  code
end

