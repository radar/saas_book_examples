require "rails_helper"

feature "User sign in" do
  extend SubdomainHelpers
  let!(:account) { FactoryGirl.create(:account) }
  let(:sign_in_url) { "http://#{account.subdomain}.example.com/sign_in" }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  within_account_subdomain do
    scenario "signs in as an account owner successfully" do
      visit root_url
      expect(page.current_url).to eq(sign_in_url)
      fill_in "Email", :with => account.owner.email
      fill_in "Password", :with => "password"
      click_button "Sign in"
      expect(page).to have_content("You are now signed in.")
      expect(page.current_url).to eq(root_url)
    end
  end
end