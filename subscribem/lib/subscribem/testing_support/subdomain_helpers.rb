module Subscribem
  module TestingSupport
    module SubdomainHelpers
      def within_account_subdomain(&block)
        context "within a subdomain" do
          let(:subdomain_url) { "http://#{account.subdomain}.example.com" }
          before { Capybara.default_host = subdomain_url } 
          after { Capybara.default_host = "http://example.com" }
          yield
        end
      end
    end
  end
end