require_dependency "subscribem/application_controller"

module Subscribem
  class AccountsController < ApplicationController
    def new
      @account = Subscribem::Account.new
      @account.build_owner
    end

    def create
      account = Subscribem::Account.create(account_params)
      env["warden"].set_user(account.owner, :scope => :user)
      env["warden"].set_user(account, :scope => :account)
      flash[:success] = "Your account has been successfully created."
      redirect_to subscribem.root_url
    end

    private

    def account_params
      params.require(:account).permit(:name, {:owner_attributes => [
        :email, :password, :password_confirmation
      ]})
    end
  end
end
