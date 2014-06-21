require "rails_helper"

feature "Account scoping" do
  let!(:account_a) { FactoryGirl.create(:account_with_schema) }
  let!(:account_b) { FactoryGirl.create(:account_with_schema) }

  before do
    Apartment::Database.switch(account_a.subdomain)
    Thing.create(:name => "Account A's Thing")

    Apartment::Database.switch(account_b.subdomain)
    Thing.create(:name => "Account B's Thing")

    Apartment::Database.reset
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