Factory.define :user do |user|
  user.login 'anonymous'
  user.association :person, :factory => :person
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
  index.association :student
  index.association :study
  index.association :tutor
  index.association :coridor
  index.association :department
end

Factory.define :study do |study|
  study.name 'prezenční'
  study.name_en 'full time'
end

Factory.define :coridor do |c|
  c.name 'coridor'
  c.name_english 'en coridor'
  c.code 'COR'
  c.association :faculty, :factory => :faculty
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
