class AddBraintreeSubscriptionIdToSubscribemAccounts < ActiveRecord::Migration
  def change
    add_column :subscribem_accounts, :braintree_subscription_id, :string
  end
end
