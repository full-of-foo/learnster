# operations

Given(/^I update the account details$/) do
  page = Pages::SettingsPage.new(@browser)

  new_first_name, new_surname = TestDataGenerator.first_name, TestDataGenerator.last_name

  page.submit_settings_form(new_first_name, new_surname)
  StepsDataCache.current_user.first_name = new_first_name
  StepsDataCache.current_user.surname = new_surname
end


# assertions

Then(/^I see the settings the page$/) do
  user = StepsDataCache.current_user
  sleep(0.3)

  step("I should see a \"input\" with the \"value\" of \"#{user.first_name}\"")
  step("I should see a \"input\" with the \"value\" of \"#{user.surname}\"")
  step("I should see a \"span\" with the \"text\" of \"#{user.email}\"")

  step("I should see a \"button\" with the \"id\" of \"Update\"")
  step("I should see a \"button\" with the \"id\" of \"Cancel\"")
end
