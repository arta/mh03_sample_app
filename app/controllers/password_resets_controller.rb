class PasswordResetsController < ApplicationController
  before_action :set_user,                    only: [:edit, :update]
  before_action :authenticate_activated_user, only: [:edit, :update]
  before_action :check_expiration,            only: [:edit, :update]

  # GET /password_resets/new
  #   html:   <a href='/password_resets/new'>..</a>
  #   rails:  =link_to .. new_password_reset_path
  #   router: get 'password_resets/new', to: 'password_resets#new'
  def new
  end
  # Implicitly renders /password_resets/new.html.erb, which contains:
  #   <form action='/password_resets', method='post' ..>
  #     <input name='password_reset[email]'..>
  #     ...

  # POST /password_resets
  #   html:   <form action='/password_resets', method='post' ..>
  #             <input name='password_reset[email]' ..>
  #             ...
  #   rails:  =form_for :password_reset, url: 'password_resets_path'
  #             =f.email_field :email
  #             ...
  #   router: post '/password_resets', to: 'password_resets#create'
  def create
    @user = User.find_by( email: params[:password_reset][:email].downcase )
    # Must be @user (not user) for password resets integration test 
    # assigns( :user ) to work
    if @user
      @user.create_reset_digest
      @user.email_password_reset_link
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  # No vieww. Explicitly sends email containing:
  #   html:   <a href='/password_resets/reset_token/edit?email=escapedemail'>..</a>

  # GET /password_resets/:id/edit?email=some@email.com # :id is assigned a reset_token
  #   html:   <a href='/password_resets/reset_token/edit?email=escapedemail'>..</a>
  #   rails:  =link_to .. edit_reset_password_path( @user.reset_token, email: @user.email )
  #   router: get '/password_resets/:id/edit', to: 'password_resets#edit'
  def edit
  end
  # Implicitly renders /password_resets/edit.html.erb which contains:
  #   html:   <form action='/password_resets/reset_token', method='patch'..>
  #             <input name='email', type='hidden', ..>
  #             <input name='user[password]', ..>
  #             <input name='user[password_confirmation]', ..>'

  # PATCH /password_resets/:id
  #   html:   <form action='/password_resets/reset_token', method='patch'..>
  #             <input name='email', type='hidden', ..>
  #             <input name='user[password]', ..>
  #             <input name='user[password_confirmation]', ..>
  #   rails:  =form_for @user, url: password_reset_path( params[:id] ) ..
  #             =f.hidden_field_tag :email, @user.email
  #             =f.password_field :password
  #             =f.password_field :password_confirmation
  #   router: patch '/password_resets/:id', to: 'password_resets#update'
  def update
    if params[:user][:password].empty? # User password validation allows nil
      @user.errors.add( :password, "can't be empty" )
      render 'edit'
    elsif @user.update( user_params )
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  # No explicit view; redirect_to|render @user|'edit'

  private
    def set_user
      @user = User.find_by email: params[:email]
    end

    def authenticate_activated_user
      redirect_to root_path unless @user &&
        @user.activated? &&
        @user.authenticated?( :reset, params[:id] )
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

    def user_params
      params.require( :user ).permit( :password, :password_confirmation )
    end
end
