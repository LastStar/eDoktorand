Feature: New feature
  In order to create study plan
  student
  needs page for creating it

  Scenario: Creating of study plan
    Given I am student with account "student"
    And I have logged in
    Then I should see "create study plan"
    When I follow "create study plan"
    Then I should see "obligate subjects"
