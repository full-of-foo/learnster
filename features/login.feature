@user-login

Feature: User Login 
	Students login to student dashboards
	Admins login to organisation dashboards
	Super Admins login to admin dashboards

Scenario: Super Admin login
	Given I navigate to the "login" page
	Then I should see the login form button
	And I can login with a known "super admin"
	Then I should see "foo"


	