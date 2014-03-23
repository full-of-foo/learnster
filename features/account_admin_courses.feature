@account_admin_courses

Feature: Account Admin Courses
  CRUDs on courses and course section

@account_admin_courses-1
Scenario: CRUD Course
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  And I click the "h1" with the "text" of "Courses"
  And I should not see a "td" with the "text" of "No courses found :("

  # create course
  Then I click the "link" with the "id" of "new-course-button"
  And I should see the text "Courses can be used for units of teaching that typical consist of more than one term"
  Then I click the "button" with the "class" of "cancel-new-course"
  And I create a Course
  Then I see the Course show page
  And I should see a "td" with the "text" of "No course sections exist :("

  # edit course
  Then I edit the Course
  Then I see the Course show page

  # create course section
  And I create a Course Section
  Then I see the Course Section show page
  And I should see a "td" with the "text" of "No modules added :("
  And I click the "link" with the "text" of "Students"
  And I should see a "td" with the "text" of "No students added :("

  # add/remove module
  Then I add the first Module to the Course Section
  Then I see the Course Section show page
  And I should see a "a" with the "id" of "add-module-button"
  And I see the first Module on the Course Section
  Then I remove the first Module from the Course Section
  And I should see a "td" with the "text" of "No modules added :("

  # add/remove student
  Then I add the first Student to the Course Section
  Then I see the Course Section show page
  And I should see a "a" with the "id" of "add-student-button"
  And I see the first Student on the Course Section
  Then I remove the first Student from the Course Section
  And I should see a "td" with the "text" of "No students added :("

  # delete course section
  Then I delete the Course Section
  Then I see the Course show page
  And I should see a "td" with the "text" of "No course sections exist :("

  #delete course
  Then I delete the Course
  And I should not see the deleted Course



