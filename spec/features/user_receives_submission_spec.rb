require 'rails_helper'

feature "User receives submission", { js: true, vcr: true } do
  before do
    Capybara.current_driver = :selenium
    account = Account.create(email: 'email@gmail.com')
    Website.create(domain: 'einsteinboards.com', verified: true, account: account)
  end

  scenario "visitor fills out form" do
    visit "http://einsteinboards.com/form_for_feature_test.html" # note to submit form to port used by selenium (e.g. http://localhost:52662/)
    fill_in "email", with: "john.doe@gmail.com"
    fill_in "message", with: "Hey there, great website!"
    click_button "Send"
    open_email "email@gmail.com"
    expect(current_email).to have_content 'Hey there, great website!'
  end
end

  
# HTML code from form:

# <form action="http://localhost:52662/email@gmail.com" method="POST">
#     <input name="email" type="email">
#     <input name="message" type="text">
#     <input value="Send" type="submit">
# </form> 