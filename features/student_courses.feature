@student_courses

Feature: Student Courses
  Reads on courses and course sections

@student_courses-1
Scenario: CRUD Course
  Given I navigate to the "login" page
  And I attempt to login with a known "student"
  Then I sidebar navigate to "My Courses"

  # cannot create course
  And I should not see a "a" with the "id" of "new-course-button"
  And I open the first Course

  # cannot create course section
  And I should not see a "a" with the "id" of "new-course-section-button"
