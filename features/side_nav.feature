@side-nav

Feature: Side Nav
  Sidebar navigations

@side-nav-1
Scenario: Sessionless sidebar navigation
  Given I navigate to the "login" page
  Then the "Sign in" nav is active
  And I should see the text "The easy way to learn..."
  Then I sidebar navigate to "Sign up Organisation"
  Then the "Sign up Organisation" nav is active
  Then I should see a "li" with the "id" of "intro-crumb"
  Given I navigate to the "sign up" page
  Then the "Sign up Organisation" nav is active
  Then I should see a "li" with the "id" of "intro-crumb"
  Then I sidebar navigate to "Sign in"
  And I should see the text "The easy way to learn..."
  Then the "Sign in" nav is active

# @side-nav-2
# Scenario: System admin sidebar navigation
#   Given I navigate to the "login" page
#   And I attempt to login with a known "system admin"

