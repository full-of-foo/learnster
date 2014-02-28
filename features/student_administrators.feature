@student_administrators

Feature: Student Administrators
  Reads on admins

@student_administrators-1
Scenario: Read Admins
  Given I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Educators"

  # cannot create admin
  And I should not see a "td" with the "text" of "No admins found :("
  And I should not see a "a" with the "id" of "new-org-admin-button"

  # cannot edit admin
  Then I open the first Admin
  Then I see the Admin show page


