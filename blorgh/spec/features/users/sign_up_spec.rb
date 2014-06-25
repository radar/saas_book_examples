require "rails_helper"
require "subscribem/testing_support/factories/account_factory"

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  scenario "under an account" do
    visit root_url
    click_link "Sign in"
    click_link "New User?"
    fill_in "Email", :with => "user@example.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign up"
    expect(page).to have_content("You have signed up successfully.")
    expect(page.current_url).to eq(root_url)
    expect(page).to have_content("Signed in as user@example.com")
  end
end