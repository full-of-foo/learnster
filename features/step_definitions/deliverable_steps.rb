# opertations

Given(/^I create a Deliverable$/) do
  page = Pages::DeliverablesPage.new(@browser)

  title, description, due_date =
    TestDataGenerator.title, TestDataGenerator.description, "01/01/2014"
  deliverable = CacheEntities::Deliverable.new(title: title, description: description, due_date: due_date)

  page.submit_new_deliverable_form(deliverable)
  StepsDataCache.deliverable = deliverable
end

Given(/^I edit the Deliverable$/) do
  page = Pages::DeliverablesPage.new(@browser)
  title, description, due_date =
    TestDataGenerator.title, TestDataGenerator.description, "01/01/2015"

  page.submit_edit_deliverable_form(title, description, due_date)

  StepsDataCache.deliverable.title       = title
  StepsDataCache.deliverable.description = description
  StepsDataCache.deliverable.due_date    = due_date
end

Given(/^I delete the Deliverable$/) do
  deliverable = StepsDataCache.deliverable

  sleep(0.3)
  step("I click the \"span\" with the \"id\" of \"delete-deliverable-button\"")
  sleep(0.2)
  step("I click the \"button\" with the \"id\" of \"delete-deliverable-button\"")

  StepsDataCache.deleted_deliverable = deliverable
  StepsDataCache.deliverable = nil
end

Given(/^I open the Deliverable$/) do
  page = Pages::DeliverablesPage.new(@browser)
  deliverable = StepsDataCache.deliverable

  step("I should see a \"th\" with the \"text\" of \"Title\"")
  sleep(0.3)

  step("I click the \"td\" with the \"text\" of \"#{deliverable.title}\"")
end

Given(/^I create a Wiki Submission$/) do
  page = Pages::DeliverablesPage.new(@browser)

  notes, markup = TestDataGenerator.lorem_word, TestDataGenerator.lorem_word

  wiki = CacheEntities::WikiSubmission.new(notes: notes, wiki_markup: markup)

  page.submit_new_wiki_submission(wiki)
  StepsDataCache.wiki_submission = wiki
end

Given(/^I edit the Wiki Submission$/) do
  page = Pages::DeliverablesPage.new(@browser)
  notes, markup = TestDataGenerator.lorem_word, TestDataGenerator.lorem_word

  page.submit_update_wiki_submission(notes, markup)

  StepsDataCache.old_wiki_submission =
    CacheEntities::WikiSubmission.new(notes: StepsDataCache.wiki_submission.notes,
                                        wiki_markup: StepsDataCache.wiki_submission.wiki_markup)
  StepsDataCache.wiki_submission.notes       = notes
  StepsDataCache.wiki_submission.wiki_markup = markup
end

Given(/^I open the Wiki Submission$/) do
  page = Pages::DeliverablesPage.new(@browser)
  wiki_submission = StepsDataCache.wiki_submission

  step("I should see a \"th\" with the \"text\" of \"Notes\"")
  sleep(0.3)

  step("I click the \"td\" with the \"text\" of \"#{wiki_submission.notes}\"")
end

Given(/^I open the first Wiki Version$/) do
  step('I click the "span" with the "class" of "timestamp"')
end

Given(/^I revert to this Wiki Version$/) do
  step('I click the "span" with the "id" of "revert-wiki-button"')

  new_wiki_swap_var = StepsDataCache.wiki_submission
  StepsDataCache.wiki_submission =
    CacheEntities::WikiSubmission.new(notes: StepsDataCache.old_wiki_submission.notes,
                                        wiki_markup: StepsDataCache.old_wiki_submission.wiki_markup)
  StepsDataCache.old_wiki_submission =
    CacheEntities::WikiSubmission.new(notes: new_wiki_swap_var.notes, wiki_markup: new_wiki_swap_var.wiki_markup)
end

# assertions

Then(/^I see the Deliverable show page$/) do
  deliverable = StepsDataCache.deliverable

  step("I should see a \"span\" with the \"text\" of \"#{deliverable.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{deliverable.description}\"")
  step("I should see a \"span\" with the \"text\" of \"#{deliverable.due_date}\"")
end

Then(/^I see the Wiki Submission show page$/) do
  wiki_submission = StepsDataCache.wiki_submission

  step("I should see a \"span\" with the \"text\" of \"#{wiki_submission.notes}\"")
end

Then(/^I see the first Wiki Submission version page$/) do
  old_wiki_submission = StepsDataCache.old_wiki_submission
  sleep(1.2)

  step("I should see a \"p\" with the \"text\" of \"Showing Previous Version...\"")
  step("I should see a \"span\" with the \"text\" of \"#{old_wiki_submission.notes}\"")
end

Then(/^I see the first Wiki Version in the versions list$/) do
  step('I should see a "span" with the "class" of "timestamp"')
end
