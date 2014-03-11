@versionable_submissions

Feature: Versionable Submissions

@versionable_submissions-1
Scenario: Submission Reverts
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "My Learning Modules"

  # create module, supplement and deliverable
  And I create a Module
  And I create a Supplement for the Module
  Then I click the "link" with the "id" of "deliverables-tab"
  And I click the "link" with the "id" of "new-deliverable-button"
  And I create a Deliverable

  # add module and student to course
  Then I sidebar navigate to "All Courses"
  And I open the first Course
  Then I create a Course Section
  Then I add a known Module to the Course Section
  Then I add my Student to the Course Section
  Then I attempt to logout

  # student submission create
  Then I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Deliverables"
  And I open the Deliverable
  And I click the "link" with the "id" of "new-wiki-submission-button"
  And I create a Wiki Submission
  And I open the Wiki Submission
  Then I see the Wiki Submission show page
  Then I should see a "span" with the "text" of "No previous versions exist :("

  # edit and view version
  And I click the "span" with the "id" of "edit-wiki-button"
  And I edit the Wiki Submission
  Then I see the Wiki Submission show page
  Then I see the first Wiki Version in the versions list
  And I open the first Wiki Version
  And I see the first Wiki Submission version page
  Then I click the "span" with the "id" of "cancel-wiki-version"
  Then I see the Wiki Submission show page

  # revert and view version
  And I open the first Wiki Version
  Then I revert to this Wiki Version
  Then I see the Wiki Submission show page
  And I open the first Wiki Version
  And I see the first Wiki Submission version page
  Then I attempt to logout

  # admin reads
  Then I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "My Deliverables"
  And I open the Deliverable
  And I open the Wiki Submission
  Then I see the first Wiki Version in the versions list
  And I open the first Wiki Version
  And I see the first Wiki Submission version page
  And I should not see a "span" with the "id" of "revert-wiki-button"


