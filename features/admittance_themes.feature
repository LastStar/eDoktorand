Feature: Admission form
  In order to choose right admittance theme
  As a candidate
  I need to select it in admittance form

  Scenario: Showing admittance theme
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    When I am on the admittance page
    And I follow "Low"
    Then I should see "Nice work"

  @selenium
  Scenario: Setting admittance theme
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    When I fill all on the admittance page
    And I select "Nice work (Tutor Tutorov)" from "candidate_admittance_theme_id"
    And I press "Odeslat"
    Then I should see "Nice work"

  Scenario: Changing themes by department
