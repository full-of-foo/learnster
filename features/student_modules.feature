@student_modules

Feature: Student Modules
  CRUDs on modules, supplements and supplement contents

@student_modules-1
Scenario: CRUD Modules
  Given I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Courses"
  And I should not see a "td" with the "text" of "No modules found :("

  # cannot create module
  And I should not see a "a" with the "id" of "new-module-button"
  Then I open the first Module

  # cannot edit or delete module
  And I should not see a "span" with the "id" of "edit-module-button"
  And I should not see a "span" with the "id" of "delete-module-button"

  # cannot create supplement
  And I should not see a "a" with the "id" of "add-module-supplement-button"
