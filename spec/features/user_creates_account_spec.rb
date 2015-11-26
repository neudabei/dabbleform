require 'rails_helper'

feature "User creates account" do
  scenario "user creates account" do
    visit "https://s3-eu-west-1.amazonaws.com/storefilesrsj/form_for_feature_test.html"
    save_and_open_page
  end

  scenario "user confirms account" do
  end
end