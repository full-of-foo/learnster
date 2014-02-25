@course_admin_administrators

Feature: Course Admin Administrators
  Reads on admins

@course_admin_administrators-1
Scenario: Read Admins
  Given I navigate to the "login" page
  And I attempt to login with a known "course admin"
  Then I sidebar navigate to "All Administrators"

  # cannot create admin
  And I should not see a "td" with the "text" of "No admins found :("
  And I should not see a "a" with the "id" of "new-org-admin-button"

  # cannot edit admin
  Then I open the first Admin
  Then I see the Admin show page


