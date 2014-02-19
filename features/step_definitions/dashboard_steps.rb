# assertions
Then(/^I see the account administrator dashboard$/) do
  step("I wait \"5\" seconds while the spinner is present")

  sleep 0.3

  step("I should see a \"h1\" with the \"text\" of \"Courses\"")
  step("I should see a \"h1\" with the \"text\" of \"Modules\"")
  step("I should see a \"h1\" with the \"text\" of \"Module Files\"")
  step("I should see a \"h1\" with the \"text\" of \"Notifications\"")
end
