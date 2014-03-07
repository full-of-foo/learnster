@student_admin_contents

Feature: Student Admin Contents
  Reads on contents

@student_admin_contents-1
Scenario: Read Contents
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  Then I sidebar navigate to "My Learning Modules"

  # create and add student
  And I create a Module
  And I create a Supplement for the Module
  And I create a wiki content
  Then I see the wiki content listed
  Then I sidebar navigate to "All Courses"
  And I open the first Course
  Then I create a Course Section
  Then I add a known Module to the Course Section
  Then I add my Student to the Course Section
  Then I attempt to logout

  # student read
  Then I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Learning Modules"
  And I open the Module
  And I open the Supplement
  Then I see the wiki content listed
  Then I open the wiki content
  And I see the wiki content show page
  And I should not see a "span" with the "id" of "edit-wiki-button"
