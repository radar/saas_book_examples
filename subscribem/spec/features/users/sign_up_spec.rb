require "rails_helper"

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  scenario "under an account" do
    visit root_url
    expect(page.current_url).to eq(root_url + "sign_in")
    click_link "New User?"
    fill_in "Email", :with => "user@example.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign up"
    expect(page).to have_content("You have signed up successfully.")
    expect(page.current_url).to eq(root_url)
  end
end