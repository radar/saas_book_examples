require "rails_helper"
require "subscribem/testing_support/factories/account_factory"
require "subscribem/testing_support/authentication_helpers"

feature "Accounts" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let(:account) { FactoryGirl.create(:account) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  context "as the account owner" do
    before do
      sign_in_as(:user => account.owner, :account => account)
    end

    scenario "updating an account" do
      visit root_url
      click_link "Edit Account"
      fill_in "Name", :with => "A new name"
      click_button "Update Account"
      expect(page).to have_content("Account updated successfully.")
      expect(account.reload.name).to eq("A new name")
    end

    scenario "updating an account with invalid attributes fails" do 
      visit root_url
      click_link "Edit Account"
      fill_in "Name", :with => ""
      click_button "Update Account"
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Account could not be updated.")
    end

    context "with plans" do
      let!(:starter_plan) do
        Subscribem::Plan.create(
          :name  => "Starter",
          :price => 9.95,
          :braintree_id => "starter"
        )
      end

      let!(:extreme_plan) do
        Subscribem::Plan.create(
          :name  => "Extreme",
          :price => 19.95,
          :braintree_id => "extreme"
        )
      end

      let(:query_string) do
        Rack::Utils.build_query(
          :plan_id => extreme_plan.id,
          :http_status => 200,
          :id => "a_fake_id",
          :kind => "create_customer",
          :hash => "689ee0446812eb1fdea052d45c30c7beea15053d"
        )
      end

      before do
        account.update_column(:plan_id, starter_plan.id)
      end

      scenario "updating an account's plan" do
        subscription_params = {
          :payment_method_token => "abcdef",
          :plan_id => extreme_plan.braintree_id
        }

        subscription_result = double(:success? => true,
                                   :subscription => double(:id => "abc123"))

        expect(Braintree::Subscription).to receive(:create).
          with(subscription_params).
          and_return(subscription_result)

        query_string = Rack::Utils.build_query(
          :plan_id => extreme_plan.id,
          :http_status => 200,
          :id => "a_fake_id",
          :kind => "create_customer",
          :hash => "689ee0446812eb1fdea052d45c30c7beea15053d"
        )
        mock_transparent_redirect_response = double(:success? => true)
        allow(mock_transparent_redirect_response).
          to(receive_message_chain(:customer, :credit_cards).
          and_return([double(:token => "abcdef")]))
        expect(Braintree::TransparentRedirect).to receive(:confirm).
          with(query_string).
          and_return(mock_transparent_redirect_response)

        visit root_url
        click_link "Edit Account"
        select "Extreme", :from => 'Plan'
        click_button "Update Account"
        expect(page).to have_content("Account updated successfully.")
        plan_url = subscribem.plan_account_url(
          :plan_id => extreme_plan.id,
          :subdomain => account.subdomain)
        expect(page.current_url).to eq(plan_url)
        expect(page).to have_content("You are changing to the 'Extreme' plan")
        expect(page).to have_content("This plan costs $19.95 per month.")
        fill_in "Credit card number", with: "4111111111111111"
        fill_in "Name on card", with: "Dummy user"
        future_date = "#{Time.now.month + 1}/#{Time.now.year + 1}"
        fill_in "Expiration date", with: future_date
        fill_in "CVV", with: "123"
        click_button "Change plan"
        expect(page).to have_content("You have switched to the 'Extreme' plan.")
        expect(page.current_url).to eq(root_url)
        expect(account.reload.braintree_subscription_id).to eq("abc123")
      end

      scenario "can't change account's plan with invalid credit card number" do
        message = "Credit card number must be 12-19 digits"
        result = double(:success? => false, :message => message)

        allow(Braintree::TransparentRedirect).to receive(:confirm).
          with(query_string).
          and_return(result)

        visit root_url
        click_link "Edit Account"
        select "Extreme", :from => 'Plan'
        click_button "Update Account"
        expect(page).to have_content("Account updated successfully.")
        plan_url = subscribem.plan_account_url(
          :plan_id => extreme_plan.id,
          :subdomain => account.subdomain)
        expect(page.current_url).to eq(plan_url)
        expect(page).to have_content("You are changing to the 'Extreme' plan")
        expect(page).to have_content("This plan costs $19.95 per month.")
        fill_in "Credit card number", :with => "1"
        fill_in "Name on card", :with => "Dummy user"
        future_date = "#{Time.now.month + 1}/#{Time.now.year + 1}"
        fill_in "Expiration date", :with => future_date
        fill_in "CVV", :with => "123"
        click_button "Change plan"
        expect(page).to have_content("Invalid credit card details. Please try again.")
        expect(page).to have_content("Credit card number must be 12-19 digits")
      end

      scenario "changing plan after initial subscription" do
        expect(Braintree::Subscription).to receive(:update).
          with("abc123", {:plan_id => extreme_plan.braintree_id}).
          and_return(double(:success? => true))
        account.update_column(:braintree_subscription_id, "abc123")
        visit root_url
        click_link "Edit Account"
        select "Extreme", :from => 'Plan'
        click_button "Update Account"
        expect(page).to have_content("You are changing to the 'Extreme' plan.")
        expect(page).to have_content("This plan costs $19.95 per month.")
        click_button "Change plan"
        expect(page).to have_content("You have switched to the 'Extreme' plan.")
        expect(page.current_url).to eq(root_url)
        expect(account.reload.plan).to eq(extreme_plan)
      end

      scenario "changing plan after initial subscription fails" do
        expect(Braintree::Subscription).to receive(:update).
          and_return(double(:success? => false))
        account.update_column(:braintree_subscription_id, "abc123")
        visit root_url
        click_link "Edit Account"
        select "Extreme", :from => 'Plan'
        click_button "Update Account"
        expect(page).to have_content("You are changing to the 'Extreme' plan.")
        expect(page).to have_content("This plan costs $19.95 per month.")
        click_button "Change plan"
        expect(page).to have_content("Something went wrong. Please try again.")
      end
    end
  end

  context "as a user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in_as(:user => user, :account => account)
    end

    scenario "cannot edit an account's information" do
      visit subscribem.edit_account_url(:subdomain => account.subdomain)
      expect(page).to have_content("You are not allowed to do that.")
    end
  end
end