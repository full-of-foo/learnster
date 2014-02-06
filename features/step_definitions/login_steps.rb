
# operations

Given(/^I attempt to login with a known "(.+)"$/) do |user_type_str|
  raise "No user type supplied" if user_type_str.blank? or user_type_str.nil?
  page = Pages::LoginPage.new(@browser)

  case user_type_str
  when "app admin"
    @user = { email: "lightweightdevelopment@gmail.com", password: "foobar" }
  when "admin"
    @user = { email: "admin@foo.com", password: "foobar" }
  when "student"
    @user = { email: "student@foo.com", password: "foobar" }
  else
    raise "invalid user type"
  end

  page.attempt_login(@user[:email], @user[:password])

  StepsDataCache.current_user_email = @user[:email]
  StepsDataCache.current_user_pass = @user[:password]
  sleep 1
end

Given(/^I attempt to logout$/) do
  nav = Pages::HeaderNav.new(@browser)
  nav.attempt_logout

  StepsDataCache.current_user_email, StepsDataCache.current_user_pass = nil, nil
  sleep 0.3
end


# assertions

Then(/^I should see the login form button$/) do
  raise "Cannot see the login button" if not Pages::LoginPage.new(@browser).login_button.exist?
end
