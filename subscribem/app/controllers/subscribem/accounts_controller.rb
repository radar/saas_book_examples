require_dependency "subscribem/application_controller"

module Subscribem
  class AccountsController < ApplicationController
    def new
      @account = Subscribem::Account.new
    end

    def create
      account = Subscribem::Account.create(account_params)
      flash[:success] = "Your account has been successfully created."
      redirect_to subscribem.root_url
    end
    
    private

    def account_params
      params.require(:account).permit(:name)
    end
  end
end
