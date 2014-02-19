
# operations

Given(/^I attempt to login with a known "(.+)"$/) do |user_type_str|
  raise "No user type supplied" if user_type_str.blank? or user_type_str.nil?
  page = Pages::LoginPage.new(@browser)

  case user_type_str
  when "app admin"
    @user = CacheEntites::User.new("Foo", "McBar", "lightweightdevelopment@gmail.com", "foobar")
  when "admin"
    @user = CacheEntites::User.new("Foo", "McBar", "admin@foo.com", "foobar")
  when "new admin"
    @user = CacheEntites::User.new("Foo", "McBar", "signup@foo.com", "foobar")
  when "student"
    @user = CacheEntites::User.new("Foo", "McBar", "student@foo.com", "foobar")
  else
    raise "invalid user type"
  end

  StepsDataCache.current_user = @user
  page.attempt_login(@user.email, @user.password)
  sleep 0.8

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
