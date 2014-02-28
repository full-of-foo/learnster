@user_settings

Feature: User Settings Page
  Updates on given user accounts

@user_settings-1
Scenario: Account Admin Settings
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I topbar navigate to "Settings"
  Then I update the account details
  Then the "Dashboard" nav is active
  And I should see the text "Modules"
  Then I topbar navigate to "Settings"
  And I see the settings the page

@user_settings-2
Scenario: Account Admin Settings
  Given I navigate to the "login" page
  And I attempt to login with a known "course admin"
  Then I topbar navigate to "Settings"
  Then I update the account details
  Then the "Dashboard" nav is active
  And I should see the text "My Module Files"
  Then I topbar navigate to "Settings"
  And I see the settings the page

@user_settings-3
Scenario: Account Admin Settings
  Given I navigate to the "login" page
  And I attempt to login with a known "module admin"
  Then I topbar navigate to "Settings"
  Then I update the account details
  Then the "Dashboard" nav is active
  And I should see the text "My Module Files"
  Then I topbar navigate to "Settings"
  And I see the settings the page

@user_settings-4
Scenario: Account Admin Settings
  Given I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I topbar navigate to "Settings"
  Then I update the account details
  Then the "Dashboard" nav is active
  And I should see the text "My Module Files"
  Then I topbar navigate to "Settings"
  And I see the settings the page
