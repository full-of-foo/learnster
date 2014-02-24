@side_nav

Feature: Side Nav
  Sidebar navigations

@side_nav-1
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

  Then I topbar navigate to "About"
  And I should see the text "Free lightweight learning platform to educate the world..."
  Then no sidenavs are active

@side_nav-2
Scenario: System admin sidebar navigation
  Given I navigate to the "login" page
  And I attempt to login with a known "system admin"
  Then the "Organisations" nav is active

  Then I sidebar navigate to "Organisations"
  Then the "Organisations" nav is active
  And I should see the text "Organisations..."

  Then I sidebar navigate to "Administrators"
  Then the "Administrators" nav is active
  And I should see the text "Organisation Administrators..."

  Then I sidebar navigate to "Students"
  Then the "Students" nav is active
  And I should see the text "Students..."

  Then I topbar navigate to "Notifications"
  And I should see the text "Application Notifications"
  Then no sidenavs are active

@side_nav-3
Scenario: Account admin sidebar navigation
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then the "Dashboard" nav is active

  Then I sidebar navigate to "Dashboard"
  Then the "Dashboard" nav is active
  Then I should see a "h1" with the "text" of "Courses"

  Then I sidebar navigate to "All Administrators"
  Then the "All Administrators" nav is active
  Then I should see a "a" with the "id" of "new-org-admin-button"

  Then I sidebar navigate to "All Students"
  Then the "All Students" nav is active
  Then I should see a "a" with the "id" of "new-student-button"

  Then I topbar navigate to "Notifications"
  And I should see the text "Organisation Notifications"
  Then no sidenavs are active

@side_nav-4
Scenario: Course admin sidebar navigation
  Given I navigate to the "login" page
  And I attempt to login with a known "course admin"
  Then the "Dashboard" nav is active

  Then I sidebar navigate to "Dashboard"
  Then the "Dashboard" nav is active
  And I should see the text "Modules"

  Then I sidebar navigate to "My Courses"
  Then the "My Courses" nav is active
  And I should see the text "My Courses..."

  Then I sidebar navigate to "My Learning Modules"
  Then the "My Learning Modules" nav is active
  And I should see the text "My Learning Modules..."

  Then I sidebar navigate to "All Administrators"
  Then the "All Administrators" nav is active
  Then I should see a "a" with the "id" of "new-org-admin-button"

  Then I sidebar navigate to "All Students"
  Then the "All Students" nav is active
  Then I should see a "a" with the "id" of "new-student-button"

  Then I topbar navigate to "Notifications"
  Then no sidenavs are active



