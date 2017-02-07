require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    # load a user
    @user = users( :michael )
    # set cookies[:user_id], cookies[:remember_token], but not session[:user_id]
    #   i.e. do not log in
    remember( @user )
    # @user ready to visit our site without being logged in 
    #   but with a valid cookie info
  end

  # User visits page asking logged_in? (e.g. any page with authentication nav)
  # logged_in? helper simply runs current_user helper to set @current_user
  # 1) current_user helper checks for session.signed[:user_id],
  # 2) if no session[:user_id], then current_user checks for cookie[:user_id]
  # if cookie[:user_id] exists, current_user finds and asks .authenticated?
  # if user.authenticated? current_user logs her in and sets @current_user
  # finally, current_user returns @current_user
  test "user with no session but with valid cookie should be logged in" do
    # @user does not have a session[:user_id]; is not logged in
    assert_not is_logged_in?
    # accept passing cookie info: @user authenticated, logged in, @current_user set
    assert_equal @user, current_user
    # @user now has a session.signed[:user_id]; is logged in
    assert is_logged_in?
  end

  test "user with no session and no valid cookie should not be logged in" do
    # @user does not have a session[:user_id]; is not logged in
    assert_not is_logged_in?
    # invalidate @user's valid cookie info
    #   to get @user with no session and no valid cookie
    @user.update_attribute( :remember_digest, User.digest( User.new_token ) )
    @user.update_attribute( :remember_digest, '' ) # -//-; value irrelevant
    # decline invalid cookie info: @user not authenticated, no session, no login
    assert_not current_user # runs authentication (and returns nil)
    assert_nil current_user # -//-
    # @user is not granted a session[:user_id]; remains not logged in
    assert_not is_logged_in?
  end
end
