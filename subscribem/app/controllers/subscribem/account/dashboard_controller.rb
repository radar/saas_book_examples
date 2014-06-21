require_dependency "subscribem/application_controller"

module Subscribem
  class Account::DashboardController < ApplicationController
    before_filter :authenticate_user!
  end
end
