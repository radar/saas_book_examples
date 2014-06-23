class Thing < ActiveRecord::Base
  extend Subscribem::ScopedTo
  def self.scoped_to(account)
    where(:account_id => account.id)
  end
end