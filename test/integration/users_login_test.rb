require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # Test to catch unwanted flash persistance:
  test "login failure flash should not persist for two pages" do
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
end
