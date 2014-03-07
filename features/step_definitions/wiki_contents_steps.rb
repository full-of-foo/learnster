# operations

Given(/^I create a wiki content$/) do
  page = Pages::SupplementPage.new(@browser)
  step('I click the "link" with the "id" of "new-wiki-content-button"')
  step('I should see a "p" with the "text" of "New Wiki..."')

  new_title, new_description, new_markup =
    TestDataGenerator.title, TestDataGenerator.description, TestDataGenerator.lorem_word
  wiki = CacheEntities::WikiContent.new(title: new_title, description: new_description, wiki_markup: new_markup)

  2.times {
    page.scroll_down
    sleep(0.6)
  }
  page.submit_new_wiki_form(wiki)
  StepsDataCache.wiki_content = wiki
end

Given(/^I open the wiki content$/) do
  wiki = StepsDataCache.wiki_content
  step("I click the \"td\" with the \"text\" of \"#{wiki.title}\"")
end

Given(/^I edit the wiki content$/) do
  page = Pages::SupplementPage.new(@browser)
  new_title, new_description, new_markup =
    TestDataGenerator.title, TestDataGenerator.description, TestDataGenerator.lorem_word

  page.submit_edit_wiki_form(new_title, new_description, new_markup)
  StepsDataCache.wiki_content.title = new_title
  StepsDataCache.wiki_content.description = new_description
  StepsDataCache.wiki_content.wiki_markup = new_markup
end

Given(/^I delete the wiki content$/) do
  page = Pages::SupplementPage.new(@browser)
  wiki = StepsDataCache.wiki_content

  cell = @browser.td(text: wiki.title)
  @browser.execute_script("$('.last-col-invisible').removeClass('last-col-invisible');")
  sleep(0.3)
  cell.parent.tds.last.div(class: "delete-icon").i.click

  step("I should see a \"button\" with the \"id\" of \"delete-content-button\"")
  step("I click the \"button\" with the \"id\" of \"delete-content-button\"")

  StepsDataCache.deleted_wiki_content = StepsDataCache.wiki_content
end


# assertions

Then(/^I see the wiki content listed$/) do
  page = Pages::SupplementPage.new(@browser)

  wiki = StepsDataCache.wiki_content
  3.times {
    page.scroll_down
    sleep(0.6)
  }
  step("I should see a \"td\" with the \"text\" of \"#{wiki.title}\"")
end

Then(/^I see the wiki content show page$/) do
  page = Pages::SupplementPage.new(@browser)
  wiki = StepsDataCache.wiki_content

  step("I should see a \"span\" with the \"text\" of \"#{wiki.title}\"")
  step("I should see a \"span\" with the \"text\" of \"#{wiki.description}\"")
end

Then(/^I see the wiki content edit page$/) do
  page = Pages::SupplementPage.new(@browser)
  wiki = StepsDataCache.wiki_content

  step("I should see a \"input\" with the \"value\" of \"#{wiki.title}\"")
  step("I should see a \"input\" with the \"value\" of \"#{wiki.description}\"")
  step("I should see a \"span\" with the \"id\" of \"preview-wiki-button\"")
end
