class Post < ActiveRecord::Base
  extend Subscribem::ScopedTo
  has_many :comments
end
