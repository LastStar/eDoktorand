Feature: Login page
  In order to login to system
  CZU
  wants login page

  Background:
    Given I have user named 'pepe'

  Scenario: Login page
    Given I am on the login page
    Then I should see "Login to system"

  Scenario: Logging in system with user without rights
    Given I am on the login page
    Then I fill my credentials
    Then I press "Submit"
    Then I should see "You don't have rights to do this"
