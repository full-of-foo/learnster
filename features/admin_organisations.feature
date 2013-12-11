@admin-organisations

Feature: Admin Organisations
	Admin organisation CRUDs

@admin-organisations-1
Scenario: Create an Organisation and it is appended to the grid
	Given I navigate to the "login" page
	And I attempt to login with a known "super admin"
	Then I navigate to the "organisations" page
	Then I should see a "div" with the "id" of "orgs-region"
	And I should see the text "Organisations..."
	And I can open and close the add-organisation well
	Then I create an Organisation
	And I see the Organisation edit page title
	Then I navigate to the "organisations" page
	And the Organisation is in the grid-list
	Then I search the organisation title
	And the Organisation is in the grid-list

Scenario: Edit the Organisation and it is details are updated
	Given I navigate to the "login" page
	And I attempt to login with a known "super admin"
	Then I navigate to the "organisations" page
	And I open the Organisation from the grid
	Then I edit the Organisation
	Then I navigate to the "organisations" page
	And the Organisation is in the grid-list

Scenario: Delete the Organisation and it is no longer listed
	Given I navigate to the "login" page
	And I attempt to login with a known "super admin"
	Then I navigate to the "organisations" page
	And I delete the Organisation from the grid
	And the Organisation is not in the grid-list

@admin-organisations-2
Scenario: Export Organisations and the file is downloaded
	Given I navigate to the "login" page
	And I attempt to login with a known "super admin"
	Then I navigate to the "organisations" page
	And I export the Organisations
	Then I see exported Organisations have been downloaded




	