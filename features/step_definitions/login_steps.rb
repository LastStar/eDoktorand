Then /^I fill my credentials$/ do
  fill_in :login, :with => 'pepe'
  fill_in :password, :with => 'pepe'
end

Given /^I have user named '(.+)'$/ do |user_name|
  Factory(:user, :login => user_name)
end
  
