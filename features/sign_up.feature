@sign_up

Feature: Sign up

Scenario: Signing up an organisation
  Given I navigate to the "sign up" page
  And I should see the text "Lets get started, eh?"
  Then I continue to the administrator sign up step
  And I should see the text "Create your administrator account..."
  Then I sign up an account admin
  And I should see the text "Registration Email Sent"
  And I attempt to confirm the sign up
  And I should see the text "Your Organisation..."
  Then I sign up an organisation
  And I should see the text "Registration Complete"
  Then I should see a "button" with the "id" of "secondary-button"
  And I attempt to login with a known "new admin"
  Then I see the account administrator dashboard

@sign_up-2
Scenario: Navigating around a new organisation
  Given I navigate to the "login" page
  And I attempt to login with a known "new admin"
  Then I should see a "p" with the "text" of "no courses"
  Then I should see a "p" with the "text" of "no modules"
  Then I should see a "p" with the "text" of "no notifications"
  Then I should see a "p" with the "text" of "no files"
  Then I topbar navigate to "Notifications"
  And I should see a "h3" with the "text" of "no notifications just quite yet"
  Then I topbar navigate to "Home"
  And I click the "h1" with the "text" of "Modules"
  And I should see a "td" with the "text" of "No modules found :("
  Then I topbar navigate to "Home"
  And I click the "h1" with the "text" of "Courses"
  And I should see a "td" with the "text" of "No courses found :("
  Then I topbar navigate to "Statistics"
  And I click the "p" with the "text" of "Student Enrollment Trend"
  And I should see a "p" with the "text" of "Oops! No data to plot this time range"
