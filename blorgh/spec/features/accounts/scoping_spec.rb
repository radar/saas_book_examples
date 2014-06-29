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
    visit posts_url(:subdomain => account_a.subdomain) 
    expect(page).to have_content("Account A's Post")
    expect(page).to_not have_content("Account B's Post")
  end

  scenario "displays only account B's records" do
    visit posts_url(:subdomain => account_b.subdomain) 
    expect(page).to have_content("Account B's Post")
    expect(page).to_not have_content("Account A's Post")
  end

  scenario "Account A's post is visible on Account A's subdomain" do
    account_a_post = Post.scoped_to(account_a).first
    visit post_url(account_a_post, :subdomain => account_a.subdomain)
    expect(page).to have_content("Account A's Post")
  end

  scenario "Account A's post is invisible on Account B's subdomain" do
    account_a_post = Post.scoped_to(account_a).first
    expect do 
      visit post_url(account_a_post, :subdomain => account_b.subdomain)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end