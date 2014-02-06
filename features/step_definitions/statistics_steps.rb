# assertions
Then(/^there exists some statistics$/) do
  sleep 0.6

  step("I should see a \"ul\" with the \"class\" of \"fa-ul stat-summary-list\"")
  step("I should see a \"div\" with the \"class\" of \"well well-small\"")
end
