@account_admin_students

Feature: Account Admin Students
  CRUDs on students

@account_admin_students-1
Scenario: CRUD Students
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "All Students"
  And I should not see a "td" with the "text" of "No students found :("

  # create student
  Then I click the "link" with the "id" of "new-student-button"
  And I should see the text "Accounts that can be enrolled to study on course sections, and in turn particpate in that course section's learning modules"
  Then I click the "button" with the "class" of "cancel-new-student"
  And I create a Student
  Then I see the Student edit page

  # edit student
  Then I edit the Student
  Then I open the Student edit page
  Then I see the Student edit page
  Then I click the "button" with the "id" of "Cancel"
  Then I sidebar navigate to "My Students"
  And I should not see a "td" with the "text" of "No students found :("
  Then I open the Student edit page
  Then I see the Student edit page
  Then I click the "button" with the "id" of "Cancel"

  #delete course
  Then I delete the Student
  And I should not see the deleted Student
