# operations

Given(/^I sidebar navigate to "(.+)"$/) do |nav_text|
  page = Pages::SideNav.new(@browser)

  case nav_text
  when "Sign in"
    page.side_nav_to(page.sign_in_nav_link)
  when "Sign up Organisation"
    page.side_nav_to(page.sign_up_nav_link)
  when "Organisations"
    page.side_nav_to(page.orgs_nav_link)
  when "Administrators"
    page.side_nav_to(page.app_admins_nav_link)
  when "Students"
    page.side_nav_to(page.app_students_nav_link)
  when "Dashboard"
    page.side_nav_to(page.dash_nav_link)
  when "All Administrators"
    page.side_nav_to(page.all_admins_nav_link)
  when "All Students"
    page.side_nav_to(page.all_students_nav_link)
  when "All Courses"
    page.side_nav_to(page.all_courses_nav_link)
  when "My Administrators"
    page.side_nav_to(page.my_admins_nav_link)
  when "My Educators"
    page.side_nav_to(page.my_admins_nav_link)
  when "My Students"
    page.side_nav_to(page.my_students_nav_link)
  when "My Courses"
    page.side_nav_to(page.my_courses_nav_link)
  when "My Learning Modules"
    page.side_nav_to(page.my_modules_nav_link)
  else
    raise "Unknown navigation item text: '#{nav_text}'"
  end

end

# assertions

Then(/^the "(.+)" nav is active$/) do |nav_text|
  page = Pages::SideNav.new(@browser)

  case nav_text
  when "Sign in"
    link_class = page.sign_in_nav_link.when_present.parent.class_name
  when "Sign up Organisation"
    link_class = page.sign_up_nav_link.when_present.parent.class_name
  when "Organisations"
    link_class = page.orgs_nav_link.when_present.parent.class_name
  when "Administrators"
    link_class = page.app_admins_nav_link.when_present.parent.class_name
  when "Students"
    link_class = page.app_students_nav_link.when_present.parent.class_name
  when "Dashboard"
    link_class = page.dash_nav_link.when_present.parent.class_name
  when "All Administrators"
    link_class = page.all_admins_nav_link.when_present.parent.class_name
  when "All Students"
    link_class = page.all_students_nav_link.when_present.parent.class_name
  when "All Courses"
    link_class = page.all_courses_nav_link.when_present.parent.class_name
  when "My Courses"
    link_class = page.my_courses_nav_link.when_present.parent.class_name
  when "My Learning Modules"
     link_class = page.my_modules_nav_link.when_present.parent.class_name
  when "My Educators"
     link_class = page.my_admins_nav_link.when_present.parent.class_name
  else
    raise "Unknown navigation item text: '#{nav_text}'"
  end

  raise "'#{nav_text}' class is '#{link_class}', not 'active'" if link_class != "active"
end

Then(/^no sidenavs are active$/) do
  page = Pages::SideNav.new(@browser)
  sleep(0.3)

  step("I should not see a \"li\" with the \"class\" of \"active\"")
end

