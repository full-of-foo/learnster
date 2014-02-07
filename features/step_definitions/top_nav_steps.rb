# operations

Given(/^I topbar navigate to "(.+)"$/) do |nav_text|
  page = Pages::TopNav.new(@browser)

  case nav_text
  when "Home"
    page.top_nav_to(page.home_nav_link)
  when "Notifications"
    page.top_nav_to(page.notifications_nav_link)
  when "Statistics"
    page.top_nav_to(page.stats_nav_link)
  else
    raise "Unknown navigation item text: '#{nav_text}'"
  end

end