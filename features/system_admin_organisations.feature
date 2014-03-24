@system_admin_organisations

Feature: Admin Organisations
	Admin organisation CRUDs

@system_admin_organisations-1
Scenario: Cannot create an Organisation
	Given I navigate to the "login" page
	And I attempt to login with a known "system admin"
	Then I navigate to the "organisations" page
	Then I should see a "div" with the "id" of "orgs-region"
	And I should see the text "Organisations..."
	And I should not see a "link" with the "text" of "New Organisation"

@system_admin_organisations-2
Scenario: Edit the Organisation and it is details are updated
	Given I navigate to the "login" page
	And I attempt to login with a known "system admin"
	Then I navigate to the "organisations" page
	And I open the DIT Organisation from the grid
	Then I edit the Organisation
	Then I navigate to the "organisations" page
	And the Organisation is in the grid-list

@system_admin_organisations-3
Scenario: Delete the Organisation and it is no longer listed
	Given I navigate to the "login" page
	And I attempt to login with a known "system admin"
	Then I navigate to the "organisations" page
	And I delete the DIT Organisation from the grid
	And the Organisation is not in the grid-list

@system_admin_organisations-4
Scenario: Export Organisations and the file is downloaded
	Given I navigate to the "login" page
	And I attempt to login with a known "system admin"
	Then I navigate to the "organisations" page
	And I export the Organisations
	Then I see exported Organisations have been downloaded





