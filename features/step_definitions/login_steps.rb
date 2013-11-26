
# operations

Given(/^I navigate to the "(.+)" page$/) do  |page|
  raise "No page name supplied" if page.blank? or page.nil?
  
  case page
  when "login"
    page = Pages::LoginPage.new(@browser)
  else
    raise "invalid page name"
  end

  page.visit
  page.resize_window  
end

Given(/^I can login with a known "(.+)"$/) do |user_type_str|
  raise "No user type supplied" if user_type_str.blank? or user_type_str.nil?

  page = Pages::LoginPage.new(@browser)
  
  case user_type_str
  when "super admin"
    user = FactoryGirl.create(:super_admin)
  when "admin"
    user = FactoryGirl.create(:admin)
  when "student"
    user = FactoryGirl.create(:student)
  else
    raise "invalid user type"
  end

  page.attempt_login(user.email, "foobar")
end


# assertions

Then(/^I should see the login form button$/) do
  raise "Cannot see the login button" if not Pages::LoginPage.new(@browser).login_button.exist?
end
