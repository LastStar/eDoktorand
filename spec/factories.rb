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
  s.uic 1
end

Factory.define :tutor do |t|
  t.firstname 'Tutor'
  t.lastname 'Tutorov'
  t.association :title_before, :factory => :title
  t.association :title_after, :factory => :title, :prefix => false
  t.uic 666
end

Factory.define :faculty_secretary do |fs|
  fs.firstname 'Tutor'
  fs.lastname 'Tutorov'
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
  program.name 'program'
  program.name_english 'program'
  program.code 'PRG'
end

Factory.define :faculty do |f|
  f.name 'faculty'
  f.name_english 'en faculty'
  f.short_name 'FAC'
  f.stipendia_code "666"
  f.theses_id "S4121"
end

Factory.define :department do |department|
  department.name "department"
  department.name_english "department en"
  department.short_name 'DEP'
  department.code '11100'
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
  candidate.faculty 'FAPPZ'
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

Factory.define :disert_theme do |disert_theme|
  disert_theme.association :index
  disert_theme.title "Hnojit nebo nehnojit"
  disert_theme.title_en "To shit or not to shit"
  disert_theme.finishing_to 6
end

Factory.define :study_plan do |study_plan|
  study_plan.finishing_to 6
  study_plan.actual 1
  study_plan.admited_on Time.now
  study_plan.approved_on Time.now
end
