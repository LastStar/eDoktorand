Given /^I am student with account "(.+)"$/ do |user_name|
  @person = Student.make
  Index.make(:student => @person)
  @role = Role.make(:name => "student")
  @role.permissions << Permission.make(:name => 'account/welcome')
  @role.permissions << Permission.make(:name => 'study_plans/index')
  @role.permissions << Permission.make(:name => 'study_plans/create')
  @user = User.make(:login => user_name, :person => @person)
  @user.roles << @role
end

