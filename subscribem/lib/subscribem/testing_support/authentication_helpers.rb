module Subscribem
  module TestingSupport
    module AuthenticationHelpers
      include Warden::Test::Helpers

      def self.included(base)
        base.after do
          logout
        end
      end

      def sign_in_as(options={}) 
        options.each do |scope, object|
          login_as(object, :scope => scope)
        end
      end
    end
  end
end