@admittance
Feature: Admission themes in form
  In order to choose right admittance theme
  As a candidate
  I need to select it in admittance form

  Scenario: Showing admittance theme
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    When I am on the admittance page
    And I follow "Low"
    Then I should see "--- vyberte rámcové téma ---"

  Scenario: Setting admittance theme
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    When I fill all on the admittance page
    And I select "Nice work (Tutor Tutorov)" from "candidate_admittance_theme_id"
    And I press "Odeslat"
    Then I should see "Přihláška ke studiu v doktorském studijním programu"
    And I should see "Nice work"

  Scenario: Setting a theme not on department
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    And "Low" specialization has admittance theme "Bad werk" on "Bad" department with "Tutorov" tutor
    When I fill all on the admittance page
    And I select "Bad" from "Katedra"
    And I select "Nice work (Tutor Tutorov)" from "candidate_admittance_theme_id"
    And I press "Odeslat"
    Then I should see "Téma je vypsáno pro jinou katedru, než jste vybral"

  Scenario: Not setting a theme
    Given there is "Science" faculty with all set
    And "Low" specialization has admittance theme "Nice work" on "Good" department with "Tutorov" tutor
    And "Low" specialization has admittance theme "Bad werk" on "Bad" department with "Tutorov" tutor
    When I fill all on the admittance page
    And I select "Bad" from "Katedra"
    And I press "Odeslat"
    Then I should see "Vyberte prosím rámcové téma"
