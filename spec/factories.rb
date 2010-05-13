Factory.define :user do |user|
  user.login 'anonymous'
  user.association :person, :factory => :person
end

Factory.define :role do |role|
  role.name 'role'
end

Factory.define :permission do |permission|
  permission.name 'permission'
end

Factory.define :person do |p|
  p.firstname 'Pepe'
  p.lastname 'Calvera'
end

Factory.define :student do |s|
  s.firstname 'Student'
  s.lastname 'Studentov'
end

Factory.define :tutor do |s|
  s.firstname 'Tutor'
  s.lastname 'Tutorov'
end

Factory.define :index do |index|
  index.enrolled_on TermsCalculator.this_year_start
  index.association :study
  index.association :tutor
  index.association :specialization
  index.association :department
end

Factory.define :study do |study|
  study.name 'prezenční'
  study.name_en 'full time'
end

Factory.define :specialization do |specialization|
  specialization.name 'specialization'
  specialization.name_english 'en specialization'
  specialization.code 'COR'
  specialization.association :faculty, :factory => :faculty
end

Factory.define :faculty do |f|
  f.name 'faculty'
  f.name_english 'en faculty'
  f.short_name 'FAC'
end

Factory.define :department do |department|
  department.name "department"
  department.name_english "department en"
  department.association :faculty
end

Factory.define :address do |address|
  address.association :student
  address.street 'Street'
  address.desc_number '8'
  address.city 'City'
  address.zip '11111'
end
