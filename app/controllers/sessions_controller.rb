class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :destroy, with: :reset_session

  def new
  end
  
  def create
    user = User.find_by email: params[:session][:email].downcase

    if user.try :authenticate, params[:session][:password]
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
