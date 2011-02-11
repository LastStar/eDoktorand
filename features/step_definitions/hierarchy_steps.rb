Given /^there is "(.+)" faculty with all set$/ do |faculty|
  Faculty.destroy_all
  Specialization.destroy_all
  Department.destroy_all
  Title.destroy_all
  Subject.destroy_all
  LanguageSubject.destroy_all
  AdmittanceTheme.destroy_all
  @faculty = Factory(:faculty, :name => faculty)
  first_specialization = Factory(:specialization, :name => "Low", :faculty => @faculty, :accredited => true)
  Factory(:specialization, :name => "High", :faculty => @faculty, :accredited => true)
  Factory(:department, :name => "Good", :faculty => @faculty)
  Factory(:department, :name => "Bad", :faculty => @faculty)
  Factory(:title, :prefix => true)
  subject1 = Factory(:subject, :label => 'Subject 1', :code => 'CD1')
  subject2 = Factory(:subject, :label => 'Subject 2', :code => 'CD2')
  Factory(:language_subject, :specialization => first_specialization, :subject => subject1)
  Factory(:language_subject, :specialization => first_specialization, :subject => subject2)
  Factory(:study)
end

Given /^"([^"]*)" specialization has admittance theme "([^"]*)" on "([^"]*)" department with "([^"]*)" tutor$/ do |specialization, theme, department, tutor|
  AdmittanceTheme.create(:name => theme,
                      :specialization => Specialization.find_by_name(specialization),
                      :department => Department.find_by_name(department),
                      :tutor => Factory(:tutor, :lastname => tutor))
end

