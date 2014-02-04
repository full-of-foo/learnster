# operations

Given(/^I sidebar navigate to "(.+)"$/) do |nav_text|
  page = Pages::SideNav.new(@browser)

  case nav_text
  when "Sign in"
    page.side_nav_to(page.sign_in_nav_link)
  when "Sign up Organisation"
    page.side_nav_to(page.sign_up_nav_link)
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
  else
    raise "Unknown navigation item text: '#{nav_text}'"
  end

  raise "'#{nav_text}' class is '#{link_class}', not 'active'" if link_class != "active"
end
