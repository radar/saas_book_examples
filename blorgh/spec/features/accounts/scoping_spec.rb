require 'rails_helper'
require "subscribem/testing_support/authentication_helpers"
require "subscribem/testing_support/factories/account_factory"

feature "Account scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    Post.scoped_to(account_a).create(:title => "Account A's Post")
    Post.scoped_to(account_b).create(:title => "Account B's Post")
  end

  scenario "displays only account A's records" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    visit posts_url(:subdomain => account_a.subdomain) 
    expect(page).to have_content("Account A's Post")
    expect(page).to_not have_content("Account B's Post")
  end

  scenario "displays only account B's records" do
    sign_in_as(:user => account_b.owner, :account => account_b)
    visit posts_url(:subdomain => account_b.subdomain) 
    expect(page).to have_content("Account B's Post")
    expect(page).to_not have_content("Account A's Post")
  end
end