require_dependency "subscribem/application_controller"

module Subscribem
  class Account::AccountsController < ApplicationController
    before_filter :authenticate_user!
    before_filter :authorize_owner, only: [:edit, :update]

    def update
      plan_id = account_params.delete(:plan_id)
      if current_account.update_attributes(account_params)
        flash[:success] = "Account updated successfully."
        if plan_id != current_account.plan_id
          redirect_to plan_account_url(:plan_id => plan_id)
        else
          redirect_to root_path
        end
      else
        flash[:error] = "Account could not be updated."
        render :edit
      end
    end

    private

    def account_params
      params.require(:account).permit(:name, :plan_id)
    end
  end
end