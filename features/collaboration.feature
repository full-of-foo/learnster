@collaboration

Feature: Collaboration Acceptance

@collaboration-1
Scenario: Basic Collaboration Acceptance
  Given I navigate to the "login" page
  And I attempt to login with a known "account admin"
  And I should see a "li" with the "id" of "collaborate-dock-item"

  # open acceptance
  Then I click the "li" with the "id" of "collaborate-dock-item"
  Then I should see a "div" with the "id" of "togetherjs-walkthrough"
  And I should see a "div" with the "id" of "togetherjs-container"
  And I should see a "div" with the "class" of "basic-success"
  And I should not see a "div" with the "class" of "basic-loader"
  And I click the "button" with the "text" of "I'm ready!"

  # close acceptance
  And I click the "button" with the "id" of "togetherjs-profile-button"
  And I should see a "div" with the "id" of "togetherjs-menu-end"
  Then I click the "div" with the "id" of "togetherjs-menu-end"
  And I should see a "button" with the "id" of "togetherjs-end-session"
  Then I click the "button" with the "id" of "togetherjs-end-session"
  And I should not see a "div" with the "class" of "basic-loader"
  And I should not see a "div" with the "id" of "togetherjs-container"
  And I should not see a "div" with the "class" of "basic-success"

  # sign out acceptance
  Then I click the "li" with the "id" of "collaborate-dock-item"
  And I should see a "div" with the "id" of "togetherjs-container"
  And I should see a "div" with the "class" of "basic-success"
  Then I attempt to logout
  Then I should see the text "The easy way to learn..."
  And I should not see a "div" with the "class" of "basic-loader"
  And I should not see a "div" with the "id" of "togetherjs-container"
  And I should not see a "div" with the "class" of "basic-success"

