@onboarding_dialog

Feature: Onboarding dialog

@onboarding_dialog-1
Scenario: Student onboarding
  Given I navigate to the "login" page
  And I attempt to login with a known unboarded "student"
  Then I should see the text "Welcome to Learnster!"
  Then I should see the text "As a student your educators assign you to courses and modules where you can begin learning!"
  And I click the "button" with the "text" of "Continue and don't show again"
  Then I attempt to logout
  And I attempt to login with a known "student"
  And I should not see a "p" with the "text" of "Welcome to Learnster!"
  And I should not see a "p" with the "text" of "As a student your educators assign you to courses and modules where you can begin learning!"

@onboarding_dialog-2
Scenario: Module admin onboarding
  Given I navigate to the "login" page
  And I attempt to login with a known unboarded "module admin"
  Then I should see the text "Welcome to Learnster!"
  Then I should see the text "As a module manager you can create and manage your modules and their contents!"
  And I click the "button" with the "text" of "Continue and don't show again"
  Then I attempt to logout
  And I attempt to login with a known "module admin"
  And I should not see a "p" with the "text" of "Welcome to Learnster!"
  And I should not see a "p" with the "text" of "As a module manager you can create and manage your modules and their contents!"

@onboarding_dialog-3
Scenario: Course admin onboarding
  Given I navigate to the "login" page
  And I attempt to login with a known unboarded "course admin"
  Then I should see the text "Welcome to Learnster!"
  Then I should see the text "As a course manager you can create and manage your modules in addition to managing your courses!"
  And I click the "button" with the "text" of "Continue and don't show again"
  Then I attempt to logout
  And I attempt to login with a known "course admin"
  And I should not see a "p" with the "text" of "Welcome to Learnster!"
  And I should not see a "p" with the "text" of "As a course manager you can create and manage your modules in addition to managing your courses!"

@onboarding_dialog-4
Scenario: Account admin onboarding
  Given I navigate to the "login" page
  And I attempt to login with a known unboarded "account admin"
  Then I should see the text "Welcome to Learnster!"
  Then I should see the text "As an account manager you can create and manage all courses, modules, managers and students in your organisation!"
  And I click the "button" with the "text" of "Continue and don't show again"
  Then I attempt to logout
  And I attempt to login with a known "account admin"
  And I should not see a "p" with the "text" of "Welcome to Learnster!"
  And I should not see a "p" with the "text" of "As an account manager you can create and manage all courses, modules, managers and students in your organisation!"



