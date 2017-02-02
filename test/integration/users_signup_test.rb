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
  end
end
