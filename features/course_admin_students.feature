@course_admin_students

Feature: Course Admin Students
  Reads on students

@course_admin_students-1
Scenario: Read Student
  Given I navigate to the "login" page
  And I attempt to login with a known "course admin"
  Then I sidebar navigate to "All Students"

  # cannot create student
  And I should not see a "td" with the "text" of "No students found :("
  And I should not see a "a" with the "id" of "new-student-button"

  # cannot edit student
  Then I open the first Student
  Then I see the Student show page
