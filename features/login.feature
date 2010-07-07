Feature: Login page
  In order to login to system
  CZU
  wants login page

  Scenario: Login page
    Given I am on the login page
    Then I should see "Login to system"

  Scenario: Logging in system with user without rights
    Given I have user named "pepe"
    And I am on the login page
    Then I fill my credentials
    Then I press "login-button"
    Then I should see "You don't have rights to do this"

   Scenario: Login user with student rights
    Given I am student with account "pepe"
    And I am on the login page
    Then I fill my credentials
    Then I press "login-button"
    Then I should see "Study plan"
    Then I should see "Tutor"
    Then I should see "Department"
    Then I should see "create study plan"
