Given /^I am student with account "(.+)"$/ do |user_name|
  @person = Factory(:student)
  @person.index = Factory.build(:index)
  @role = Factory(:role, :name => "student")
  @role.permissions << Factory(:permission, :name => 'account/welcome')
  @role.permissions << Factory(:permission, :name => 'study_plans/index')
  @user = Factory(:user, :login => user_name, :person => @person)
  @user.roles << @role
end

