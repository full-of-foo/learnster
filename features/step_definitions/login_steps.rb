
# operations

Given(/^I attempt to login with a known "(.+)"$/) do |user_type_str|
  raise "No user type supplied" if user_type_str.blank? or user_type_str.nil?
  page = Pages::LoginPage.new(@browser)

  case user_type_str
  when "system admin"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McSystemadmin",
      email: "lightweightdevelopment@gmail.com", password: "foobar")
  when "account admin"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McAccmgr",
      email: "admin@foo.com", password: "foobar")
  when "course admin"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McCourseadmin",
      email: "courseadmin@foo.com", password: "foobar")
  when "module admin"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McModuleadmin",
      email: "moduleadmin@foo.com", password: "foobar")
  when "new admin"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McBar",
      email: "signup@foo.com", password: "foobar")
  when "student"
    @user = CacheEntities::User.new(first_name: "Foo", surname: "McStudent",
      email: "student@foo.com", password: "foobar")
  else
    raise "invalid user type"
  end

  StepsDataCache.current_user = @user
  page.attempt_login(@user.email, @user.password)
  sleep 0.8
end

Given(/^I attempt to login with a known unboarded "(.+)"$/) do |user_type_str|
  @browser.cookies.delete 'user_onboarded'

  step("I attempt to login with a known \"#{user_type_str}\"")
end

Given(/^I attempt to logout$/) do
  nav = Pages::HeaderNav.new(@browser)
  nav.attempt_logout

  StepsDataCache.current_user, StepsDataCache.organisation = nil, nil
  sleep 0.3
end


# assertions

Then(/^I should see the login form button$/) do
  raise "Cannot see the login button" if not Pages::LoginPage.new(@browser).login_button.exist?
end
