class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :edit, :update, :destroy]
  before_action :authorize_user,    only: [:edit, :update]
  before_action :authorize_admin,   only: :destroy

  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      flash[:success] = 'Welcome to the Sample App!'
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    
    if @user.update user_params
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find( params[:id] ).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private
    def user_params
      params.require( :user ).permit( :name, :email, 
        :password, :password_confirmation )
    end

    def authenticate_user
      unless current_user.present?
        store_location
        flash[:danger] = 'Please, log in.'
        redirect_to login_path
      end
    end
    alias_method :logged_in_user, :authenticate_user

    def authorize_user
      @user = User.find params[:id]
      redirect_to root_path unless current_user?( @user )
    end
    alias_method :correct_user, :authorize_user

    def authorize_admin
      redirect_to root_path unless current_user.admin?
    end
    alias_method :admin_user, :authorize_admin
end
