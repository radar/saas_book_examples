require "rails_helper"
require "subscribem/testing_support/factories/account_factory"
require "subscribem/testing_support/authentication_helpers"

feature "Account scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers

  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    Thing.scoped_to(account_a).create(:name => "Account A's Thing")
    Thing.scoped_to(account_b).create(:name => "Account B's Thing")
  end

  scenario "displays only account A's records" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    visit main_app.things_url(:subdomain => account_a.subdomain) 
    expect(page).to have_content("Account A's Thing")
    expect(page).to_not have_content("Account B's Thing")
  end

  scenario "displays only account B's records" do
    sign_in_as(:user => account_b.owner, :account => account_b)
    visit main_app.things_url(:subdomain => account_b.subdomain) 
    expect(page).to have_content("Account B's Thing")
    expect(page).to_not have_content("Account A's Thing")
  end
end