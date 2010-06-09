Feature: Admission form
  In order to fill in admission form
  as a candidate
  needs page for it

  Background:
    Given there is "Science" faculty with all set

  Scenario: Choosing specialization
    Given I am on the admission page
    Then I should see "Science"
    Then I should see "Low"
    When I follow "Low"
    Then I should see "Fields in red are required"

  Scenario: Filling admission form
    Given I am on the admission page
    And I follow "Low"
    When I fill in "firstname" with "Josef"
    When I fill in "lastname" with "Novák"
