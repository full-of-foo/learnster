@account_admin_administrators

Feature: Account Admin Administrators
  CRUDs on admins

@account_admin_administrators-1
Scenario: CRUD Admins
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "All Administrators"
  And I should not see a "td" with the "text" of "No admins found :("

  # create admin
  And I create an Admin
  Then I see the Admin edit page

  # edit admin
  Then I edit the Admin
  Then I open the Admin edit page
  Then I see the Admin edit page
  Then I click the "button" with the "id" of "Cancel"
  Then I sidebar navigate to "My Administrators"
  And I should not see a "td" with the "text" of "No admins found :("
  Then I open the Admin edit page
  Then I see the Admin edit page
  Then I click the "button" with the "id" of "Cancel"

  #delete course
  Then I delete the Admin
  And I should not see the deleted Admin
