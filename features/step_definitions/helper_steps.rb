
# Operations
Given(/^I click the "(.+)" with the "(.+)" of "(.+)"$/) do |element_type, attribute, value|
  element = ElementHelper.get_element(@browser, element_type, attribute, value)

  step "I should see a \"element_type\" with the \"attribute\" of \"value\""

  element.click
end


# Assertions 
Then(/^I should see a "(.+)" with the "(.+)" of "(.+)"$/) do |element_type, attribute, value|
  element = ElementHelper.get_element(@browser, element_type, attribute, value)
  
  raise "Cannot find: #{element_type}, #{attribute}, #{value}" if !(element.visible? and element.exists?)
end

Then(/^I should see the text "(.+)"$/) do |text|
  sleep(0.2)

  raise "The text '#{text}' is not on screen" if not @browser.text.include?(text)
end

class ElementHelper

  def self.get_element(browser, element_type, attribute, value)
    browser.send(element_type, { attribute.to_sym => value })
  end
  
end