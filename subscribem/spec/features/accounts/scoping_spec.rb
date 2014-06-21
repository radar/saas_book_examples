require "rails_helper"

feature "Account scoping" do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    Thing.create(:name => "Account A's Thing", :account => account_a)
    Thing.create(:name => "Account B's Thing", :account => account_b)
  end

  scenario "displays only account A's records" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    visit "/things"
    expect(page).to have_content("Account A's Thing")
    expect(page).to_not have_content("Account B's Thing")
  end

  scenario "displays only account B's records" do
    sign_in_as(:user => account_b.owner, :account => account_b)
    visit "/things"
    expect(page).to have_content("Account B's Thing")
    expect(page).to_not have_content("Account A's Thing")
  end
end