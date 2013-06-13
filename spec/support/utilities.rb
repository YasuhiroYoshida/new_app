include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_title do |title|
  match do |page|
    page.should have_selector('title', text: title)
  end
end

RSpec::Matchers.define :have_h1 do |h1|
  match do |page|
    page.should have_selector('h1', text: h1)
  end
end

RSpec::Matchers.define :have_a_link do |link_name, link|
  match do |page|
    page.should have_link(link_name, href: link)
  end
end
