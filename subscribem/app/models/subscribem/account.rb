module Subscribem
  class Account < ActiveRecord::Base
    belongs_to :owner, :class_name => "Subscribem::User"
    accepts_nested_attributes_for :owner
    validates :subdomain, :presence => true, :uniqueness => true

    EXCLUDED_SUBDOMAINS = %w(admin)
    validates_exclusion_of :subdomain, :in => EXCLUDED_SUBDOMAINS, 
      :message => "is not allowed. Please choose another subdomain."

    validates_format_of :subdomain, :with => /\A[\w\-]+\Z/i,
                        :message => "is not allowed. Please choose another subdomain." 

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end
  end
end
