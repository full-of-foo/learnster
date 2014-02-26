@user-login

Feature: User Login
	Students login to student dashboards
	Admins login to organisation dashboards
	Super Admins login to admin dashboards

@user-login-1
Scenario: Super Admin login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."

	And I attempt to login with a known "system admin"
	Then I should see the text "system administrator"
	Then I should see a "div" with the "id" of "destroy-session-icon"

	Then I attempt to logout
	Then I should see the text "The easy way to learn..."

@user-login-2
Scenario: Account Admin login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."

	And I attempt to login with a known "account admin"
	Then I should see the text "account manager"
	Then I should see a "div" with the "id" of "destroy-session-icon"

	Then I attempt to logout
	Then I should see the text "The easy way to learn..."

@user-login-3
Scenario: Course Admin login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."

	And I attempt to login with a known "course admin"
	Then I should see the text "course manager"
	Then I should see a "div" with the "id" of "destroy-session-icon"

	Then I attempt to logout
	Then I should see the text "The easy way to learn..."

@user-login-4
Scenario: Student login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."

	And I attempt to login with a known "student"
	Then I should see the text "student"
	Then I should see a "div" with the "id" of "destroy-session-icon"

	Then I attempt to logout
	Then I should see the text "The easy way to learn..."



