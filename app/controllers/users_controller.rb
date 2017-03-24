class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :edit, :update, :destroy,
                                           :followees, :followers]
  before_action :authorize_user,    only: [:edit, :update]
  before_action :authorize_admin,   only: :destroy

  def index
    @users = User.where( activated:true ).page( params[:page] )
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      @user.email_activation_link
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
    @microposts = @user.microposts.page params[:page]
    redirect_to root_path unless @user.activated?
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

  # GET /users/1/following
  #   see router and dev't note 3-24-17
  def followees
    @user = User.find params[:id]
    @users = @user.followees.page params[:page]
    @title = 'Following'
    render 'followship'
  end

  def followers
    @user = User.find params[:id]
    @users = @user.followers.page params[:page]
    @title = 'Followers'
    render 'followship'
  end

  private
    def user_params
      params.require( :user ).permit( :name, :email, 
        :password, :password_confirmation )
    end

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
