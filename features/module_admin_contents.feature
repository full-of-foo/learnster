@module_admin_contents

Feature: Module Admin Contents
  Cruds on contents

@module_admin_contents-1
Scenario: CRUD Contents
  Given I navigate to the "login" page
  And I attempt to login with a known "module admin"
  Then I sidebar navigate to "My Learning Modules"

  # create module and supplement
  And I create a Module
  Then I see the Module show page
  And I create a Supplement for the Module
  Then I see the Supplement show page

  # create wiki
  Then I should see the text "No contents have been set :("
  Then I click the "link" with the "id" of "new-content-upload-button"
  Then I should see the text "File contents are the uploads you share with your students"
  Then I click the "button" with the "class" of "cancel-new-content"
  Then I click the "link" with the "id" of "new-wiki-content-button"
  Then I should see the text "Wiki's can be used as a space to share content with your students which can be later updated"
  Then I click the "button" with the "class" of "cancel-new-content"
  And I create a wiki content
  Then I see the wiki content listed

  # update wiki
  Then I open the wiki content
  And I see the wiki content show page
  Then I click the "span" with the "id" of "edit-wiki-button"
  And I see the wiki content edit page
  Then I edit the wiki content
  And I see the wiki content show page
  And I should see a "span" with the "id" of "edit-wiki-button"

  # delete wiki
  Then I sidebar navigate to "My Learning Modules"
  Then I open the Module
  And I open the Supplement
  Then I see the wiki content listed
  And I delete the wiki content
  Then I should see the text "No contents have been set :("

