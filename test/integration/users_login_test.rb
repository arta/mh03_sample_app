require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
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
end
