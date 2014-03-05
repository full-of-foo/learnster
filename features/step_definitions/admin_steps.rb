# operations

Given(/^I open the new-admin well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"new-org-admin-button\"")
end

Given(/^I create an Admin$/) do
  step('I open the new-admin well')
  page = Pages::AdminsPage.new(@browser)
  params = {first_name: TestDataGenerator.first_name, surname: TestDataGenerator.last_name,
    email: TestDataGenerator.email, password: "foobar" }

  admin = CacheEntities::Admin.new(params)

  page.submit_new_admin_form(admin)
  StepsDataCache.admin = admin
end

Given(/^I edit the Admin$/) do
  page = Pages::AdminsPage.new(@browser)

  new_first_name, new_email = TestDataGenerator.first_name, TestDataGenerator.email

  page.submit_edit_admin_form(new_first_name, new_email, StepsDataCache.admin.password)
  StepsDataCache.admin.first_name = new_first_name
  StepsDataCache.admin.email = new_email
end

Given(/^I open the first Admin$/) do
  page = Pages::AdminsPage.new(@browser)

  step("I should see a \"th\" with the \"text\" of \"Name\"")
  sleep(0.6)
  full_name = @browser.tds(class: 'col-0')[0].text
  first_name = full_name.split(' ')[0]
  surname = full_name.split(' ')[1]

  admin = CacheEntities::Admin.new(first_name: first_name, surname: surname)

  step("I click the \"td\" with the \"text\" of \"#{full_name}\"")
  StepsDataCache.admin = admin
end

Given(/^I open the Admin edit page$/) do
  admin = StepsDataCache.admin
  page = Pages::AdminsPage.new(@browser)
  page.submit_search_for(admin.email)

  step("I should not see a \"td\" with the \"text\" of \"No admins found :(\"")
  step("I click the \"td\" with the \"text\" of \"#{admin.email}\"")
end

Given(/^I delete the Admin$/) do
  page = Pages::AdminsPage.new(@browser)
  admin = StepsDataCache.admin

  page.submit_search_for(admin.email)

  cell = @browser.td(text: admin.email)
  @browser.execute_script("$('.last-col-invisible').removeClass('last-col-invisible');")
  sleep(0.3)
  cell.parent.tds.last.div(class: "delete-icon").i.click

  step("I should see a \"button\" with the \"id\" of \"delete-org-admin-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-org-admin-button\"")

  StepsDataCache.deleted_admin = StepsDataCache.admin
  StepsDataCache.admin = nil
end


# assertions

Then(/^I see the Admin edit page$/) do
  admin = StepsDataCache.admin

  sleep(0.3)
  step("I should see a \"input\" with the \"value\" of \"#{admin.first_name}\"")
  step("I should see a \"input\" with the \"value\" of \"#{admin.surname}\"")
  step("I should see a \"input\" with the \"value\" of \"#{admin.email}\"")

  step("I should see a \"button\" with the \"id\" of \"Update\"")
  step("I should see a \"button\" with the \"id\" of \"Cancel\"")
end

Then(/^I see the Admin show page$/) do
  admin = StepsDataCache.admin

  sleep(0.3)
  step("I should see a \"span\" with the \"text\" of \"#{admin.first_name}\"")
  step("I should see a \"span\" with the \"text\" of \"#{admin.surname}\"")

  step("I should not see a \"button\" with the \"id\" of \"Update\"")
  step("I should not see a \"button\" with the \"id\" of \"Cancel\"")
end


Then(/^I should not see the deleted Admin$/) do
  deleted_admin = StepsDataCache.deleted_admin
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(deleted_admin.email)

  step("I should see a \"td\" with the \"text\" of \"No admins found :(\"")
end

