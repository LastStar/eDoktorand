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
    And I fill in "lastname" with "Novák"
    And I select "Ing." from "prefix title"
    And I select "24" from "candidate_birth_on_3i"
    And I select "4" from "candidate_birth_on_2i"
    And I select "1976" from "candidate_birth_on_1i"
    And I fill in "birth place" with "Praha" 
    And I select "Czech Republic" from "state"
    And I fill in "birth number / passport" with "7604242624"
    And I fill in "email" with "pepe@example.com"
    And I fill in "phone" with "+42020304050"
    And I fill in "street" with "Dlouhá"
    And I fill in "street number" with "10"
    And I fill in "city" with "Praha"
    And I fill in "zip" with "11000"
    And I select "Czech Republic" from "candidate_address_state"
    And I fill in "university" with "Czech University of Life Sciences"
    And I fill in "faculty" with "Fakulta agrobiologie, potravinových a přírodních zdrojů"
    And I fill in "corridor" with "Agronomy"
    And I select "24" from "candidate_study_end_3i"
    And I select "4" from "candidate_study_end_2i"
    And I select "2006" from "candidate_study_end_1i"
    And I select "Good" from "department"
    And I select "prezenční" from "study form"
    And I select "CD2 - Subject 2" from "candidate_language2_id"
    And I select "CD1 - Subject 1" from "candidate_language1_id"
   
