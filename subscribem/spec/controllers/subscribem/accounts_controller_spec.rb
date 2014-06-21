require "rails_helper"

describe Subscribem::AccountsController do
  context "creates the account's schema" do
    let!(:account) { Subscribem::Account.new }

    before do
      expect(Subscribem::Account).to receive(:create_with_owner).
        and_return(account)

      allow(account).to receive(:valid?) { true }
      allow(controller).to receive(:force_authentication!)
    end

    specify do
      expect(account).to receive(:create_schema)
      post :create, :account => { :name => "First Account" },
        :use_route => :subscribem
    end
  end
end
