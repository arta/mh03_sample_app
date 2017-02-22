require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users( :michael )
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    get signup_path
    assert_select 'title', full_title('Sign up')
    get users_path
    assert_redirected_to login_path
    assert_select "a[href=?]", users_path, count: 0
    log_in_as @user
    assert_redirected_to users_path
    follow_redirect! # must to check template or html elements
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", user_path( @user ), count: 2 # menu and index
    assert_select "a[href=?]", edit_user_path( @user ), count: 1
    assert_select "a[href=?]", logout_path, count: 1
    get user_path( @user )
    assert_template 'users/show'
    get edit_user_path( @user )
    assert_template 'users/edit'
    assert_select "form input" do
      assert_select "[name=?]", 'user[name]'
      assert_select "[value=?]", @user.name
    end
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", users_path, count: 0
  end
end
