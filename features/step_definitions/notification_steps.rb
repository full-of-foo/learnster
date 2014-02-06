
# assertions
Then(/^there exists some notifications$/) do
  step("I wait \"5\" seconds while the spinner is present")

  sleep 0.3

  step("I should see a \"span\" with the \"class\" of \"content\"")
  step("I should see a \"span\" with the \"class\" of \"timestamp\"")
end
