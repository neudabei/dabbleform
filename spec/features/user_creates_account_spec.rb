require 'rails_helper'

feature "User creates account" do
  before do
    Capybara.current_driver = :selenium
  end

  scenario "user creates account" do
    fill_out_form
    expect(Account.count).to eq(1)
  end

  scenario "user confirms account" do
    fill_out_form
    open_email "email@gmail.com"
    current_email.click_link "Verify your account"
    binding.pry
    expect(Account.first.websites.reload.first.verified).to eq(true)
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