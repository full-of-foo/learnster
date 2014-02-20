@top_nav

Feature: Top bar navigations

@top_nav-1
Scenario: Top navigate to items as a sessionless user
  Given I navigate to the "login" page

  Then I topbar navigate to "About"
  And I should see the text "Free lightweight learning platform to educate the world..."

  Then I topbar navigate to "Testimonials"
  And I should see the text "We’re collecting stories about some of our users that show how Learnster is helping them..."

  Then I topbar navigate to "Join"
  And I should see the text "Lets get started, eh?"

@top_nav-2
Scenario: Top navigate to items as system admin
  Given I navigate to the "login" page
  And I attempt to login with a known "system admin"

  Then I topbar navigate to "Notifications"
  And I should see the text "Application Notifications"
  And there exists some notifications

  Then I topbar navigate to "Statistics"
  And I should see the text "App Statistics"
  And there exists some statistics

  Then I topbar navigate to "Home"
  And I should see the text "Organisations..."

@top_nav-3
Scenario: Top navigate to items as account admin
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"

  Then I topbar navigate to "Notifications"
  And I should see the text "Organisation Notifications"
  And there exists some notifications

  Then I topbar navigate to "Statistics"
  And I should see the text "Organisation Statistics"
  And there exists some statistics

  Then I topbar navigate to "Home"
  And I click the "h1" with the "text" of "Courses"


