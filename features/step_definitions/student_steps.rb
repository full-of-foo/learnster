# operations

Given(/^I open the new-student well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"new-student-button\"")
end

Given(/^I create a Student$/) do
  step('I open the new-student well')
  page = Pages::StudentsPage.new(@browser)
  params = {first_name: TestDataGenerator.first_name, surname: TestDataGenerator.last_name,
    email: TestDataGenerator.email, password: "foobar" }

  student = CacheEntities::Student.new(params)

  page.submit_new_student_form(student)
  StepsDataCache.student = student
end

Given(/^I edit the Student$/) do
  page = Pages::StudentsPage.new(@browser)

  new_first_name, new_email = TestDataGenerator.first_name, TestDataGenerator.email

  page.submit_edit_student_form(new_first_name, new_email, StepsDataCache.student.password)
  StepsDataCache.student.first_name = new_first_name
  StepsDataCache.student.email = new_email
end

Given(/^I open the Student edit page$/) do
  student = StepsDataCache.student
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(student.email)

  step("I should not see a \"td\" with the \"text\" of \"No students found :(\"")
  step("I click the \"td\" with the \"text\" of \"#{student.email}\"")
end

Given(/^I delete the Student$/) do
  page = Pages::StudentsPage.new(@browser)

  student = StepsDataCache.student
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(student.email)

  cell = @browser.td(text: student.email)
  @browser.execute_script("$('.last-col-invisible').removeClass('last-col-invisible');")
  sleep(0.3)
  cell.parent.tds.last.div(class: "delete-icon").i.click

  step("I should see a \"button\" with the \"id\" of \"delete-student-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-student-button\"")

  StepsDataCache.deleted_student = StepsDataCache.student
  StepsDataCache.student = nil
end


# assertions

Then(/^I see the Student edit page$/) do
  student = StepsDataCache.student

  sleep(0.3)
  step("I should see a \"input\" with the \"value\" of \"#{student.first_name}\"")
  step("I should see a \"input\" with the \"value\" of \"#{student.surname}\"")
  step("I should see a \"input\" with the \"value\" of \"#{student.email}\"")

  step("I should see a \"button\" with the \"id\" of \"Update\"")
  step("I should see a \"button\" with the \"id\" of \"Cancel\"")
end


Then(/^I should not see the deleted Student$/) do
  deleted_student = StepsDataCache.deleted_student
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(deleted_student.email)

  step("I should see a \"td\" with the \"text\" of \"No students found :(\"")
end

