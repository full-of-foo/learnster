# operations

Given(/^I continue to the administrator sign up step$/) do
  page = Pages::SignUpPage.new(@browser)
  page.click_continue_link
end

Given(/^I sign up an account admin$/) do
  page = Pages::SignUpPage.new(@browser)
  signup_user = CacheEntities::User.new(first_name: "Foo", surname: "McBar", email: "signup@foo.com", password: "foobar")

  page.sign_up_account_admin(signup_user)
  StepsDataCache.signup_user = signup_user

  sleep(1.5)
end

Given(/^I attempt to confirm the sign up$/) do
  page = Pages::SignUpPage.new(@browser)

  page.confirm_signup(StepsDataCache.signup_user)
  sleep(0.6)
end

Given(/^I sign up an organisation$/) do
  page = Pages::SignUpPage.new(@browser)
  signup_organisation = CacheEntities::Organisation.new("New College", "Some hip ass college")

  page.sign_up_organisation(signup_organisation)
  StepsDataCache.signup_organisation = signup_organisation

  sleep(0.4)
end
