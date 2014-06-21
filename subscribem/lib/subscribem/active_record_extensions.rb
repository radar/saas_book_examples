ActiveRecord::Base.class_eval do
  def self.scoped_to_account
    belongs_to :account, :class_name => "Subscribem::Account"

    association_name = self.to_s.downcase.pluralize
    Subscribem::Account.has_many association_name.to_sym, :class_name => self.to_s
  end
end