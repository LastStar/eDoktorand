Given /^there is "(.+)" faculty with all set$/ do |faculty|
  @faculty = Faculty.make(:name => faculty)
  first_specialization = Specialization.make(:name => "Low", :faculty => @faculty)
  Specialization.make(:name => "High", :faculty => @faculty)
  Department.make(:name => "Good", :faculty => @faculty)
  Title.make(:prefix => true)
  subject1 = Subject.make(:label => 'Subject 1', :code => 'CD1')
  subject2 = Subject.make(:label => 'Subject 2', :code => 'CD2')
  LanguageSubject.make(:specialization => first_specialization, :subject => subject1)
  LanguageSubject.make(:specialization => first_specialization, :subject => subject2)
end


