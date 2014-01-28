@user-login

Feature: User Login
	Students login to student dashboards
	Admins login to organisation dashboards
	Super Admins login to admin dashboards

Scenario: Super Admin login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."
	And I attempt to login with a known "app admin"
	Then I should see a "div" with the "id" of "destroy-session-icon"
	Then I attempt to logout
	Then I should see the text "The easy way to learn..."

Scenario: Admin login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."
	And I attempt to login with a known "admin"
	Then I should see a "div" with the "id" of "destroy-session-icon"
	Then I attempt to logout
	Then I should see the text "The easy way to learn..."

Scenario: Student login
	Given I navigate to the "login" page
	Then I should see the text "The easy way to learn..."
	And I attempt to login with a known "student"
	Then I should see a "div" with the "id" of "destroy-session-icon"
	Then I attempt to logout
	Then I should see the text "The easy way to learn..."



