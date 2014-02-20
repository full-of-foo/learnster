@top-nav

Feature: Top bar navigations

@top-nav-1
Scenario: Top navigate to items as system admin
  Given I navigate to the "login" page
  And I attempt to login with a known "system admin"
  Then I should see a "div" with the "id" of "destroy-session-icon"
  And I should see a "li" with the "id" of "notifications-dock-item"
  Then I topbar navigate to "Notifications"
  And I should see the text "Application Notifications"
  And there exists some notifications
  Then I topbar navigate to "Statistics"
  And I should see the text "App Statistics"
  And there exists some statistics
  Then I topbar navigate to "Home"
  And I should see the text "Organisations..."


