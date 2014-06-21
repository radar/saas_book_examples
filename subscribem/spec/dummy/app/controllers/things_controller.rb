class ThingsController < ApplicationController
  def index
    @things = current_account.things
  end
end