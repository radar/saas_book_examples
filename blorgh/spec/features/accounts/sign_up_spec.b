require "rails_helper"

feature "Accounts" do
  scenario "creating an account" do
    visit "/"
    click_link "Account Sign Up"
    fill_in "Name", :with => "Test"
    fill_in "Subdomain", :with => "test"
    fill_in "Email", :with => "subscribem@example.com"
    password_field_id = "account_owner_attributes_password"
    fill_in password_field_id, :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Create Account"

    success_message = "Your account has been successfully created."
    expect(page).to have_content(success_message)
    expect(page).to have_content("Signed in as subscribem@example.com")
    expect(page.current_url).to eq("http://test.example.com/")
  end
end