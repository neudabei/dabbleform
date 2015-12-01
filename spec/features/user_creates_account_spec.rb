require 'rails_helper'

feature "User creates account", { js: true, vcr: true } do
  before do
    Capybara.current_driver = :selenium
  end

  scenario "user creates account" do
    fill_out_form
    expect(page).to have_content("Thanks for submitting! Please check your email email@gmail.com and verify this dabbleform for your website.")
  end

  scenario "user confirms account" do
    fill_out_form
    open_email "email@gmail.com"
    current_email.click_link "Verify your account"
    expect(page).to have_content("Thanks for verifying your website. The website einsteinboards.com is now ready to accept submissions from your dabbleform.")
  end

  private 

  def fill_out_form
    visit "http://einsteinboards.com/form_for_feature_test.html" # note to submit form to port used by selenium (e.g. http://localhost:52662/)
    fill_in "email", with: "john.doe@gmail.com"
    fill_in "message", with: "Hey there, great website!"
    click_button "Send"
  end
end


# HTML code from form:

# <form action="http://localhost:52662/email@gmail.com" method="POST">
#     <input name="email" type="email">
#     <input name="message" type="text">
#     <input value="Send" type="submit">
# </form> 