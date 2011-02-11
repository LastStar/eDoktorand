@admittance
Feature: Admission form
  In order to fill in admission form
  as a candidate
  needs page for it


  Scenario: Choosing specialization
    Given there is "Science" faculty with all set
    And I am on the admittance page
    Then I should see "Science"
    Then I should see "Low"
    When I follow "Low"
    Then I should see "Vyplňte prosím všechny údaje, jejichž popiska je červená"

  Scenario: Filling admission form
    Given there is "Science" faculty with all set
    And I am on the admittance page
    And I follow "Low"
    When I fill in "Jméno" with "Josef"
    And I fill in "Příjmení" with "Novák"
    And I select "Ing." from "titul před jménem"
    And I select "24" from "candidate_birth_on_3i"
    And I select "4" from "candidate_birth_on_2i"
    And I select "1976" from "candidate_birth_on_1i"
    And I fill in "místo narození" with "Praha"
    And I select "Česká republika" from "státní příslušnost"
    And I fill in "rodné číslo / číslo pasu cizince" with "7604242624"
    And I fill in "email" with "pepe@example.com"
    And I fill in "telefon" with "+42020304050"
    And I fill in "ulice" with "Dlouhá"
    And I fill in "candidate_number" with "10"
    And I fill in "obec" with "Praha"
    And I fill in "psč" with "11000"
    And I select "Česká republika" from "candidate_address_state"
    And I fill in "univerzita" with "Czech University of Life Sciences"
    And I fill in "fakulta" with "Fakulta agrobiologie, potravinových a přírodních zdrojů"
    And I fill in "obor" with "Agronomy"
    And I select "24" from "candidate_study_end_3i"
    And I select "4" from "candidate_study_end_2i"
    And I select "2006" from "candidate_study_end_1i"
    And I select "Good" from "Katedra"
    And I select "prezenční" from "forma studia"
    And I select "CD2 - Subject 2" from "candidate_language2_id"
    And I select "CD1 - Subject 1" from "candidate_language1_id"
    And I press "Odeslat"
    Then I should see "Přihláška ke studiu v doktorském studijním programu"



