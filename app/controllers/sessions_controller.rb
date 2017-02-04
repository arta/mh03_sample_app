class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by email: params[:session][:email].downcase

    if @user.try :authenticate, params[:session][:password]
      login @user
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new'
    end
  end
  
  def destroy
    
  end
end
