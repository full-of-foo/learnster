@module_admin_administrators

Feature: Module Admin Administrators
  Reads on admins

@module_admin_administrators-1
Scenario: Read Admins
  Given I navigate to the "login" page
  And I attempt to login with a known "module admin"
  Then I sidebar navigate to "All Administrators"

  # cannot create admin
  And I should not see a "td" with the "text" of "No admins found :("
  And I should not see a "a" with the "id" of "new-org-admin-button"

  # cannot edit admin
  Then I open the first Admin
  Then I see the Admin show page


