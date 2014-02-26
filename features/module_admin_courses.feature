@module_admin_courses

Feature: Module Admin Courses
  Reads on courses and course sections

@module_admin_courses-1
Scenario: CRUD Course
  Given I navigate to the "login" page
  And I attempt to login with a known "module admin"
  Then I sidebar navigate to "All Courses"

  # cannot create course
  And I should not see a "a" with the "id" of "new-course-button"
  And I open the first Course

  # cannot create course section
  And I should not see a "a" with the "id" of "new-course-section-button"
