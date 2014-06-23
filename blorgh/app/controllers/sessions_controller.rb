class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      flash[:success] = "You have signed in successfully."
      env['warden'].set_user(user)
      redirect_to root_path
    else
      flash[:error] = "Incorrect email or password."
      render :new
    end
  end

  def destroy
    env['warden'].reset_session!
    flash[:success] = 'You have signed out.'
    redirect_to root_path
  end
end
