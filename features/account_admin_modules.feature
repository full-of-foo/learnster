@account_admin_modules

Feature: Account Admin Modules
  CRUDs on modules, supplements and supplement contents

@account_admin_modules-1
Scenario: CRUD Course
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  And I click the "h1" with the "text" of "Modules"
  And I should not see a "td" with the "text" of "No modules found :("

  # create module
  And I create a Module
  Then I see the Module show page
  And I should see a "td" with the "text" of "No supplements added :("

  # edit module
  Then I edit the Module
  Then I see the Module show page

  # create supplement
  And I create a Supplement for the Module
  Then I see the Supplement show page
  And I should see a "td" with the "text" of "No contents have been set :("

  # delete supplement
  And I delete the Supplement on the Module
  Then I see the Module show page
  And I should see a "td" with the "text" of "No supplements added :("

   #delete course
  Then I delete the Module
  And I should not see the deleted Module
