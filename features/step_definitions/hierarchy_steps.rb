Given /^there is "(.+)" faculty with all set$/ do |faculty|
  @faculty = Factory(:faculty, :name => faculty)
  first_specialization = Factory(:specialization, :name => "Low", :faculty => @faculty)
  Factory(:specialization, :name => "High", :faculty => @faculty)
  Factory(:title)
  Factory(:language_subject, :specialization => first_specialization)
end


