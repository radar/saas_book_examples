class AddPlanIdToSubscribemAccounts < ActiveRecord::Migration
  def change
    add_column :subscribem_accounts, :plan_id, :integer
  end
end
