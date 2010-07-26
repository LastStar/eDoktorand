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

Factory.define :index do |index|
  index.enrolled_on TermsCalculator.this_year_start
  index.association :study
  index.association :tutor
  index.association :specialization
  index.association :department
  index.payment_id 1
  index.account_number '2303308001'
  index.account_number_prefix '35'
  index.account_bank_number '5500'
end

Factory.define :student do |s|
  s.firstname 'Student'
  s.lastname 'Studentov'
end

Factory.define :tutor do |s|
  s.firstname 'Tutor'
  s.lastname 'Tutorov'
end

Factory.define :study do |study|
  study.name 'prezenční'
  study.name_en 'full time'
  study.code 'D'
end

Factory.define :specialization do |specialization|
  specialization.name 'specialization'
  specialization.name_english 'en specialization'
  specialization.code 'SPE'
  specialization.msmt_code 'MSPE'
  specialization.association :faculty, :factory => :faculty
  specialization.association :program
end

Factory.define :program do |program|
  program.label 'program'
  program.label_en 'program'
  program.code 'PRG'
end

Factory.define :faculty do |f|
  f.name 'faculty'
  f.name_english 'en faculty'
  f.short_name 'FAC'
end

Factory.define :department do |department|
  department.name "department"
  department.name_english "department en"
  department.short_name 'DEP'
  department.association :faculty
end

Factory.define :address do |address|
  address.association :student
  address.street 'Street'
  address.desc_number '8'
  address.city 'City'
  address.zip '11111'
end
