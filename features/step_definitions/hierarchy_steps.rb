Given /^there is "(.+)" faculty with "(.+)" and "(.+)" specializations$/ do |faculty, first_specialization, second_specialization|
  faculty = Factory(:faculty, :name => faculty)
  faculty.specializations << Factory(:specialization, :name => first_specialization)
  faculty.specializations << Factory(:specialization, :name => second_specialization)
end

