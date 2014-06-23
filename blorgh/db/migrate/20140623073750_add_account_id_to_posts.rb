class AddAccountIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :account_id, :integer
  end
end
