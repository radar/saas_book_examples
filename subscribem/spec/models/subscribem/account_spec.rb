require "rails_helper"

describe Subscribem::Account do

  it "can be created with an owner" do
    params = {
      :name => "Test Account",
      :subdomain => "test",
      :owner_attributes => {
        :email => "user@example.com",
        :password => "password",
        :password_confirmation => "password"
      }
    }

    account = Subscribem::Account.create_with_owner(params)
    expect(account.persisted?).to eq(true)
    expect(account.users.first).to eq(account.owner)
  end

  it "cannot create an account without a subdomain" do
    account = Subscribem::Account.create_with_owner
    expect(account.valid?).to eq(false)
    expect(account.users.empty?).to eq(true)
  end
end