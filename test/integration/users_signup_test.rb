require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    # Because the deliveries array is global, we have to reset it in the setup
    # method to prevent our code from breaking if any other tests deliver email
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test 'invalid email error message' do
    get signup_path
    post signup_path, params: { user: { name: 'Valid Name',
                                       email: 'invalid@email',
                                       password: 'validpswd',
                                       password_confirmation: 'validpswd' } }
    assert_template 'users/new'
    assert_select 'div#error_explanation li', 1
    assert_select 'div#error_explanation li', { count: 1, text: 'Email is invalid' }
    assert_select 'div.field_with_errors', 2
  end
  
  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:                  'Example User',
                                         email:             'user@example.com',
                                         password:              'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal ActionMailer::Base.deliveries.size, 1
    # assignes lets us access instance variables in the corresponding action
    user = assigns( :user )
    assert_not user.activated?
    follow_redirect! # although `user` now would now stop existing in the app,
                     # we can continue using it here as a data container
    assert_template 'static_pages/home'
    assert flash.any?
    assert flash[:info].present?
    assert_select 'div.alert.alert-info', String.present?
    assert_select 'a[href=?]', login_path
    assert_not is_logged_in?
    log_in_as user
    assert_not is_logged_in?
    get edit_account_activation_path( 'invalid token', email: user.email )
    assert_not is_logged_in?
    get edit_account_activation_path( user.activation_token, email: 'wrong@email.com' )
    assert_not is_logged_in?
    get edit_account_activation_path( user.activation_token, email: user.email )
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
  test 'signup post route exists' do
    get signup_path
    assert_select "form[action=?]", signup_path
  end
end
