@twitter_feed

Feature: Twitter Feed
  Acceptance of twitter feed

@twitter_feed-1
Scenario: Feed Acceptance
  Given I navigate to the "login" page
  And I should see a "iframe" with the "class" of "twitter-timeline-rendered"
  And I attempt to login with a known "account admin"
  Then I attempt to logout
  And I should see a "iframe" with the "class" of "twitter-timeline-rendered"
