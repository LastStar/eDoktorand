Feature: New feature
  In order to fill in admission form
  as a candidate
  needs page for it

  Scenario: Choosing specialization
    Given there is 'Science' faculty with 'High' and 'Low' specializations
    And I visit '/form' 
    Then I should see 'Science faculty'

