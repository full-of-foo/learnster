# operations

Given(/^I open the add-course well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"new-course-button\"")
end

Given(/^I open the add-course-section well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"new-course-section-button\"")
end

Given(/^I open the add-module well$/) do
  step("I click the \"link\" with the \"text\" of \"Modules\"")
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"add-module-button\"")
end

Given(/^I open the remove-module well$/) do
  step("I click the \"link\" with the \"text\" of \"Modules\"")
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"remove-module-button\"")
end

Given(/^I open the add-student well$/) do
  step("I click the \"link\" with the \"text\" of \"Students\"")
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"add-student-button\"")
end

Given(/^I open the remove-student well$/) do
  step("I click the \"link\" with the \"text\" of \"Students\"")
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"remove-student-button\"")
end

Given(/^I create a Course$/) do
  step('I open the add-course well')
  page = Pages::CoursesPage.new(@browser)

  title, description, identifier = TestDataGenerator.title, TestDataGenerator.description, "some-id"
  course = CacheEntites::Course.new(title, description, identifier)

  page.submit_new_course_form(course)
  StepsDataCache.course = course
end


Given(/^I edit the Course$/) do
  step("I click the \"span\" with the \"id\" of \"edit-course-button\"")
  page = Pages::CoursesPage.new(@browser)

  new_title, new_description = TestDataGenerator.title, TestDataGenerator.description

  page.submit_edit_course_form(new_title, new_description)
  StepsDataCache.course.title = new_title
  StepsDataCache.course.description = new_description
end

Given(/^I create a Course Section$/) do
  step('I open the add-course-section well')
  page = Pages::CoursesPage.new(@browser)

  course_section = CacheEntites::CourseSection.new(TestDataGenerator.title)

  page.submit_new_course_section_form(course_section)
  StepsDataCache.course_section = course_section
end

Given(/^I add the first Module to the Course Section$/) do
  step('I open the add-module well')
  page = Pages::CoursesPage.new(@browser)

  sleep(0.4)
  module_tile = @browser.div(class:"filter-option pull-left").when_present.text
  learning_module = CacheEntites::LearningModule.new(title: module_tile)

  page.submit_add_first_module_form()
  StepsDataCache.learning_module = learning_module
end

Given(/^I remove the first Module from the Course Section$/) do
  step('I open the remove-module well')
  page = Pages::CoursesPage.new(@browser)

  page.submit_remove_first_module_form()
  StepsDataCache.learning_module = nil
end

Given(/^I add the first Student to the Course Section$/) do
  step('I open the add-student well')
  page = Pages::CoursesPage.new(@browser)

  sleep(0.4)
  student_email = @browser.div(class:"filter-option pull-left").when_present.text
  student = CacheEntites::Student.new(student_email)

  page.submit_add_first_student_form()
  StepsDataCache.student = student
end

Given(/^I remove the first Student from the Course Section$/) do
  step('I open the remove-student well')
  page = Pages::CoursesPage.new(@browser)

  page.submit_remove_first_student_form()
  StepsDataCache.student = nil
end

Given(/^I delete the Course$/) do
  page = Pages::CoursesPage.new(@browser)

  step("I click the \"span\" with the \"id\" of \"delete-course-button\"")
  sleep(0.3)
  step("I should see a \"button\" with the \"id\" of \"delete-course-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-course-button\"")

  StepsDataCache.deleted_course = StepsDataCache.course
end

Given(/^I delete the Course Section$/) do
  page = Pages::CoursesPage.new(@browser)

  step("I click the \"span\" with the \"id\" of \"delete-course-section-button\"")
  sleep(0.3)
  step("I should see a \"button\" with the \"id\" of \"delete-course-section-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-course-section-button\"")

  StepsDataCache.course_section = nil
end

# assertions

Then(/^I see the Course show page$/) do
  course = StepsDataCache.course

  sleep(0.3)
  step("I should see a \"span\" with the \"text\" of \"#{course.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{course.description}\"")
  step("I should see a \"span\" with the \"text\" of \"#{course.identifier}\"")

  step("I should see a \"a\" with the \"id\" of \"new-course-section-button\"")

  step("I should see a \"span\" with the \"id\" of \"edit-course-button\"")
  step("I should see a \"span\" with the \"id\" of \"delete-course-button\"")
end

Then(/^I see the Course Section show page$/) do
  course_section = StepsDataCache.course_section
  course = StepsDataCache.course

  sleep(0.3)
  step("I should see a \"span\" with the \"text\" of \"#{course_section.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{course.title}\"")

  step("I should see a \"span\" with the \"id\" of \"edit-course-section-button\"")
  step("I should see a \"span\" with the \"id\" of \"delete-course-section-button\"")
end

Then(/^I see the first Module on the Course Section$/) do
  learning_module = StepsDataCache.learning_module
  page = Pages::CoursesPage.new(@browser)

  page.scroll_down
  step("I should see a \"td\" with the \"text\" of \"#{learning_module.title}\"")
end

Then(/^I see the first Student on the Course Section$/) do
  student = StepsDataCache.student
  page = Pages::CoursesPage.new(@browser)

  page.scroll_down
  step("I should see a \"td\" with the \"text\" of \"#{student.email}\"")
end

Then(/^I should not see the deleted Course$/) do
  deleted_course = StepsDataCache.deleted_course
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(deleted_course.title)

  step("I should see a \"td\" with the \"text\" of \"No courses found :(\"")
end
