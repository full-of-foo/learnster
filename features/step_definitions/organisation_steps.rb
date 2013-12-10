
# operations

Given(/^I open the add-organisation well$/) do
  page = Pages::OrganisationsPage.new(@browser)
  page.open_add_well
end

Given(/^I close the add-organisation well$/) do
  page = Pages::OrganisationsPage.new(@browser)
  page.close_add_well
end

Given(/^I create an Organisation/) do
  step('I open the add-organisation well')
  page = Pages::OrganisationsPage.new(@browser)

  title, description                      = TestDataGenerator.title, TestDataGenerator.description
  StepsDataCache.organisation_title       = title
  StepsDataCache.organisation_description = description

  page.submit_new_organisation_form(title, description)
end

Given(/^I search the organisation title$/) do
  page = Pages::OrganisationsPage.new(@browser)
  title = StepsDataCache.organisation_title

  page.search_organisations_grid(title)
end


# assertions

Then(/^I can open and close the add-organisation well$/) do
  step("I open the add-organisation well")
  sleep 0.2

  step("I should see the text \"New Organisation...\"")

  step("I close the add-organisation well")
  sleep 0.2
  
  step("I should not see a \"button\" with the \"id\" of \"Add Organisation\"")
end

Then(/^the Organisation is in the grid-list$/) do
  step("I wait \"5\" seconds while the spinner is present")  

  title       = StepsDataCache.organisation_title       
  description = StepsDataCache.organisation_description

  step("I should see a \"td\" with the \"text\" of \"#{title}\"")

  step("I should see a \"td\" with the \"text\" of \"#{description}\"")
end

Then(/^I see the Organisation edit page title$/) do
  sleep(0.4)
  title = StepsDataCache.organisation_title       

  step("I should see a \"p\" with the \"text\" of \"Editing Organisation: #{title}\"")

end
