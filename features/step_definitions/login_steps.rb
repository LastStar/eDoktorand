Then /^I fill my credentials$/ do
  fill_in 'user_login', :with => 'pepe'
  fill_in 'user_password', :with => 'pepe'
end

Given /^I have user named "(.+)"$/ do |user_name|
  @user = User.make(:login => user_name)
end
  
Given /^I have logged in$/ do
  Given 'I am on the login page'
  Then 'I fill my credentials'
  Then 'I press "login-button"'
end

