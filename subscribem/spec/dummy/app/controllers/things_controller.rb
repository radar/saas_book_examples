class ThingsController < ApplicationController
  def index
    @things = Thing.all
  end
end