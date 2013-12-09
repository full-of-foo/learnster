@admin-organisations

Feature: Admin Organisations
	Admin organisation CRUDs

Scenario: Organisation CRUDs
	Given I navigate to the "login" page
	And I attempt to login with a known "super admin"
	Then I navigate to the "organisations" page
	Then I should see a "div" with the "id" of "orgs-region"
	And I should see the text "Organisations..."
	And I can open and close the add-organisation well
	Then I create an Organisation
	And the Organisation is in the grid-list
