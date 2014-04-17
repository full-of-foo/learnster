@deliverable_submissions

Feature: Deliverable
  Submissions

@deliverable_submissions-1
Scenario: CRUD Submissions and Deliverables
  Given I navigate to the "login" page
  And I attempt to login with a known "module admin"
  Then I sidebar navigate to "My Learning Modules"

  # create module and supplement
  And I create a Module
  Then I see the Module show page
  And I create a Supplement for the Module
  Then I see the Supplement show page

  # create deliverable
  Then I click the "link" with the "id" of "deliverables-tab"
  And I should see the text "No deliverables have been set :("
  And I click the "link" with the "id" of "new-deliverable-button"
  Then I should see the text "Deliverables represent some required content from students for your module or lesson"
  And I create a Deliverable
  Then I see the Deliverable show page
  And I should see a "span" with the "id" of "edit-deliverable-button"
  And I should see a "span" with the "id" of "delete-deliverable-button"
  And I should not see a "a" with the "id" of "new-submission-upload-button"
  And I should see the text "All submissions made..."

  # edit deliverable
  And I click the "span" with the "id" of "edit-deliverable-button"
  And I edit the Deliverable
  Then I see the Deliverable show page

  # delete deliverbale
  And I delete the Deliverable
  Then I see the Supplement show page
  Then I click the "link" with the "id" of "deliverables-tab"
  And I should see the text "No deliverables have been set :("

@deliverable_submissions-2
Scenario: CRUD Submissions and Deliverables
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "My Learning Modules"

  # create module, supplement and deliverable
  And I create a Module
  And I create a Supplement for the Module
  Then I see the Supplement show page
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

  # student deliverable read
  Then I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Deliverables"
  And I open the Deliverable
  Then I see the Deliverable show page
  And I should not see a "span" with the "id" of "edit-deliverable-button"

  # student deliverable create
  And I should see a "a" with the "id" of "new-submission-upload-button"
  And I click the "link" with the "id" of "new-submission-upload-button"
  Then I should see the text "Submissions as a file or zip folder for your deliverables"
  And I should see a "a" with the "id" of "new-wiki-submission-button"
  And I click the "link" with the "id" of "new-wiki-submission-button"
  Then I should see the text "Wiki are versionable submissions for your deliverables, which you can later edit and version"
  And I create a Wiki Submission

  # student wiki edit
  And I open the Wiki Submission
  Then I see the Wiki Submission show page
  And I click the "span" with the "id" of "edit-wiki-button"
  And I edit the Wiki Submission
  Then I see the Wiki Submission show page

  # admin read
  Then I attempt to logout
  Then I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "My Deliverables"
  And I open the Deliverable
  And I open the Wiki Submission
  Then I see the Wiki Submission show page
  And I should not see a "span" with the "id" of "edit-wiki-button"






