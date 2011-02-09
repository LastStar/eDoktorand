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
  index.enrolled_on '2009-09-30'
  index.association :study
  index.association :tutor
  index.association :specialization
  index.association :department
  index.payment_id 1
  index.account_number '2303308001'
  index.account_number_prefix '35'
  index.account_bank_number '5500'
  index.study_form_changed_on '2010-01-02'
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

Factory.define :candidate do |candidate|
  candidate.firstname 'Karel'
  candidate.lastname 'Marel'
  candidate.birth_at '1980-01-01'
  candidate.email 'karel@marel.cz'
  candidate.phone '+420777888999'
  candidate.street 'Long'
  candidate.number '2'
  candidate.city 'Prague'
  candidate.zip '10000'
  candidate.state 'CZ'
  candidate.university 'CZU'
  candidate.faculty 'FAAPPZ'
  candidate.studied_specialization 'Agro'
  candidate.birth_number '7604242624'
  candidate.association :department
  candidate.language1_id 1
  candidate.language2_id 2
  candidate.sex 'M'
  candidate.foreign_pay false
end

Factory.define :title do |title|
  title.label 'Ing.'
  title.prefix true
end

Factory.define :subject do |subject|
  subject.label 'Subject'
  subject.code 'CD'
end

Factory.define :language_subject do |language_subject|
  language_subject.association :specialization
  language_subject.association :subject
end
