
# operations
Given(/^I navigate to the "(.+)" page$/) do  |page|
  raise "No page name supplied" if page.blank? or page.nil?

  case page
  when "login"
    page = Pages::LoginPage.new(@browser)
  when "organisations"
    page = Pages::OrganisationsPage.new(@browser)
  when "sign up"
    page = Pages::SignUpPage.new(@browser)
  else
    raise "invalid page name"
  end

  page.visit
  page.resize_window
end

Given(/^I click the "(.+)" with the "(.+)" of "(.+)"$/) do |element_type, attribute, value|
  element = ElementHelper.get_element(@browser, element_type, attribute, value)

  step "I should see a \"element_type\" with the \"attribute\" of \"value\""

  element.click
end

Given(/^I wait "(.+)" seconds while the spinner is present$/) do |duration_str|
  @browser.div(id: "loading-container").wait_while_present(duration_str.to_i)
end


# assertions
Then(/^I should see a "(.+)" with the "(.+)" of "(.+)"$/) do |element_type, attribute, value|
  element = ElementHelper.get_element(@browser, element_type, attribute, value)

  raise "Cannot find: #{element_type}, #{attribute}, #{value}" if !(element.when_present(40).visible? and element.exists?)
end

Then(/^I should not see a "(.+)" with the "(.+)" of "(.+)"$/) do |element_type, attribute, value|
  element = ElementHelper.get_element(@browser, element_type, attribute, value)

  raise "Found: #{element_type}, #{attribute}, #{value}" if element.exists?
end

Then(/^I should see the text "(.+)"$/) do |text|
  sleep(1)

  raise "The text '#{text}' is not on screen" if not @browser.text.include?(text)
end



# helper objs
class ElementHelper

  def self.get_element(browser, element_type, attribute, value)
    browser.send(element_type, { attribute.to_sym => value })
  end

end
