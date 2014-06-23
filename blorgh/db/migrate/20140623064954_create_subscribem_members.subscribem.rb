# This migration comes from subscribem (originally 20140621114308)
class CreateSubscribemMembers < ActiveRecord::Migration
  def change
    create_table :subscribem_members do |t|
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end
end
