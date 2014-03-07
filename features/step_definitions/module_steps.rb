# operations

Given(/^I open the new-module well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"new-module-button\"")
end

Given(/^I open the new-supplement well$/) do
  sleep(0.3)
  step("I click the \"link\" with the \"id\" of \"add-module-supplement-button\"")
end

Given(/^I create a Module$/) do
  step('I open the new-module well')
  page = Pages::ModulesPage.new(@browser)

  title, description = TestDataGenerator.title, TestDataGenerator.description
  learning_module    = CacheEntities::LearningModule.new(title: title, description: description)

  page.submit_new_learning_module_form(learning_module)
  StepsDataCache.learning_module = learning_module
end

Given(/^I edit the Module$/) do
  step("I click the \"span\" with the \"id\" of \"edit-module-button\"")
  page = Pages::ModulesPage.new(@browser)

  new_title, new_description = TestDataGenerator.title, TestDataGenerator.description

  page.submit_edit_module_form(new_title, new_description)
  StepsDataCache.learning_module.title = new_title
  StepsDataCache.learning_module.description = new_description
end

Given(/^I open my first Module$/) do
  page = Pages::ModulesPage.new(@browser)

  step("I should see a \"th\" with the \"text\" of \"Title\"")
  sleep(0.3)

  title = @browser.tds(class: 'col-0')[0].text
  learning_module = CacheEntities::LearningModule.new(title: title)

  step("I click the \"td\" with the \"text\" of \"#{learning_module.title}\"")
  StepsDataCache.learning_module = learning_module
end

Given(/^I open the Module$/) do
  page = Pages::ModulesPage.new(@browser)
  step("I should see a \"th\" with the \"text\" of \"Title\"")
  sleep(0.3)

  learning_module = StepsDataCache.learning_module
  page.submit_search_for(learning_module.title)

  step("I click the \"td\" with the \"text\" of \"#{learning_module.title}\"")
end

Given(/^I open the first Module$/) do
  step("I open my first Module")
end

Given(/^I create a Supplement for the Module$/) do
  step("I open the new-supplement well")
  page = Pages::ModulesPage.new(@browser)

  title, description = TestDataGenerator.title, TestDataGenerator.description
  supplement = CacheEntities::Supplement.new(title: title, description: description)

  page.submit_new_supplement_form(supplement)
  StepsDataCache.supplement = supplement
end

Given(/^I open the Supplement$/) do
  page = Pages::ModulesPage.new(@browser)
  supplement = StepsDataCache.supplement
  2.times {
    page.scroll_down
    sleep(0.4)
  }

  step("I should see a \"td\" with the \"text\" of \"#{supplement.title}\"")
  step("I click the \"td\" with the \"text\" of \"#{supplement.title}\"")
  sleep(0.4)
  2.times {
    page.scroll_down
    sleep(0.2)
  }
end

Given(/^I delete the Supplement on the Module$/) do
  page = Pages::ModulesPage.new(@browser)

  step("I click the \"span\" with the \"id\" of \"delete-supplement-button\"")
  sleep(0.3)
  step("I should see a \"button\" with the \"id\" of \"delete-supplement-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-supplement-button\"")

  StepsDataCache.supplement = nil
end

Given(/^I delete the Module$/) do
  page = Pages::ModulesPage.new(@browser)

  step("I click the \"span\" with the \"id\" of \"delete-module-button\"")
  sleep(0.3)
  step("I should see a \"button\" with the \"id\" of \"delete-module-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-module-button\"")

  StepsDataCache.deleted_learning_module = StepsDataCache.learning_module
end


# assertions

Then(/^I see the Module show page$/) do
  learning_module = StepsDataCache.learning_module

  sleep(0.3)
  step("I should see a \"span\" with the \"text\" of \"#{learning_module.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{learning_module.description}\"")
end

Then(/^I see the Supplement show page$/) do
  supplement = StepsDataCache.supplement

  sleep(0.3)
  step("I should see a \"span\" with the \"text\" of \"#{supplement.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{supplement.description}\"")

  step("I should see a \"span\" with the \"id\" of \"delete-supplement-button\"")
  step("I should see a \"span\" with the \"id\" of \"cancel-show-supplement\"")

  step("I should see a \"a\" with the \"id\" of \"new-wiki-content-button\"")
  step("I should see a \"a\" with the \"id\" of \"new-content-upload-button\"")
end

Then(/^I should not see the deleted Module$/) do
  deleted_learning_module = StepsDataCache.deleted_learning_module
  page = Pages::CoursesPage.new(@browser)
  page.submit_search_for(deleted_learning_module.title)

  step("I should see a \"td\" with the \"text\" of \"No modules found :(\"")
end

