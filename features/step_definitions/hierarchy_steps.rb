Given /^there is "(.+)" faculty with all set$/ do |faculty|
  @faculty = Factory(:faculty, :name => faculty)
  first_specialization = Factory(:specialization, :name => "Low", :faculty => @faculty)
  Factory(:specialization, :name => "High", :faculty => @faculty)
  Factory(:department, :name => "Good", :faculty => @faculty)
  Factory(:title, :prefix => true)
  subject1 = Factory(:subject, :label => 'Subject 1', :code => 'CD1')
  subject2 = Factory(:subject, :label => 'Subject 2', :code => 'CD2')
  Factory(:language_subject, :specialization => first_specialization, :subject => subject1)
  Factory(:language_subject, :specialization => first_specialization, :subject => subject2)
end


