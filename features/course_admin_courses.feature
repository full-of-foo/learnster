@course_admin_courses

Feature: Course Admin Courses
  CRUDs on courses and course section

@course_admin_courses-1
Scenario: CRUD Course
  Given I navigate to the "login" page
  And I attempt to login with a known "course admin"
  Then I sidebar navigate to "My Courses"

  # cannot create course
  And I should not see a "a" with the "id" of "new-course-button"
  And I open my first Course
  Then I see the uneditable Course show page

  # create course section

  Then I click the "link" with the "id" of "new-course-section-button"
  And I should see the text "Course sections are the divisions or sections of your course, these could be the individual semesters or years of your course. Each having a set of enrolled students and according set of learning modules"
  Then I click the "button" with the "class" of "cancel-new-course-section"
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
  Then I see the uneditable Course show page
  And I should not see the deleted Course Section
