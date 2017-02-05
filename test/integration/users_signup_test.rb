require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test 'invalid email error message' do
    get signup_path
    post users_path, params: { user: { name: 'Valid Name',
                                       email: 'invalid@email',
                                       password: 'validpswd',
                                       password_confirmation: 'validpswd' } }
    assert_template 'users/new'
    assert_select 'div#error_explanation li', 1
    assert_select 'div#error_explanation li', { count: 1, text: 'Email is invalid' }
    assert_select 'div.field_with_errors', 2
  end
  
  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Valid Name',
                                          email: 'valid@email.com',
                                          password: 'validpswd',
                                          password_confirmation: 'validpswd' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash.any?
    assert flash[:success].present?
    assert_select 'div.alert.alert-success', String.present?
    assert_select 'a[href=?]', logout_path
    assert is_logged_in? # wouldn't `session[:user_id].present?` be better here?
  end
  
  test 'signup post route exists' do
    get signup_path
    assert_select "form[action=?]", users_path
  end
end
