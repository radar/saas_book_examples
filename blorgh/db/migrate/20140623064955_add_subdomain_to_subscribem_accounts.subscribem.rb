# This migration comes from subscribem (originally 20140621114417)
class AddSubdomainToSubscribemAccounts < ActiveRecord::Migration
  def change
    add_column :subscribem_accounts, :subdomain, :string
    add_index :subscribem_accounts, :subdomain
  end
end