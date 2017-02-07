require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    # Load user from fixtures:
    @user = users( :michael )
  end

  # Test to catch unwanted flash persistance:
  test "failed login flash should not persist for two pages" do
    # Visit the login path.
    get login_path
    # Verify that the new sessions form renders properly.
    assert_select "form[action=?]", login_path
    # Post to the sessions path with an invalid params hash.
    post login_path, params: { session: { email: 'invalid', password: '' } }
    # Verify that the new sessions form gets re-rendered and that a flash message appears.
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_equal 'Invalid email/password combination.', flash[:danger]
    # Visit another page (such as the Home page).
    get root_path
    # Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
    assert_not_equal 'Invalid email/password combination.', flash[:danger]
  end

  # Test login layout changes:  
  test 'successful login should redirect and switch user authentication navigation' do
    # Visit the login path.
    get login_path
    # Post valid information to the sessions path.
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # Verify that the login link disappears.
    assert_select 'a[href=?]', login_path, count: 0
    assert_select "a[href='/login']", false
    # Verify that a logout link appears
    assert_select 'a[href=?]', logout_path
    # Verify that a profile link appears.
    assert_select 'a[href=?]', user_path( @user )
  end
  
  # Test logout:
  test 'logout should redirect and switch user authentication navigation' do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password'} }
    assert is_logged_in?
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    # User clicks logout (again) on another tab with the app loaded:
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,        count: 0
    assert_select 'a[href=?]', user_path( @user ), count: 0
  end

  test "login with :remember_me checked remembers the user" do
    log_in_as( @user, remember_me: '1' )
    assert_not_empty cookies['remember_token']
    assert cookies['remember_token'].present? # same
  end

  test "login with :remember_me unchecked forgets the remembered user" do
    # Log in to set the cookie.
    log_in_as( @user, remember_me: '1' )
    # Log in again and verify that the previously set cookie is deleted.
    log_in_as( @user, remember_me: '0' )
    assert_empty cookies['remember_token']
    assert cookies['remember_token'].empty? # same
  end
end
