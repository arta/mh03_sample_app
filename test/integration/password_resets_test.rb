require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    # Because the deliveries array is global, we have to reset it in the setup
    # method to prevent our code from breaking if any other tests deliver email
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    #   Btw: the following post to password_resets_path is routed to 
    #        password_resets#create, which:
    #        1) sets @user, and
    #        2) creates reset_token on the @user
    #        both of which we'll use below
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # follow_redirect! #<= for didactic purposes only!
    #                      breaks the test below (user will be nil)
    #                      but we want to do a lot of back'n forth mocking
    # Password reset form
    #   Btw:  post to password_resets_path is routed to password_resets#create
    #         1) since we set @user (not user) in that controller method, and
    #         2) since we did not follow_redirect! in this test after the post
    #         the @user from the above `post password_resets_path ...`
    #         is now accessible via assigns():
    user = assigns( :user ) 
    # Wrong email
    get edit_password_reset_path( user.reset_token, email: "" )
    assert_redirected_to root_url
    # Inactive user
    user.toggle!( :activated )
    get edit_password_reset_path( user.reset_token, email: user.email )
    assert_redirected_to root_url
    user.toggle!( :activated )
    # Right email, wrong token
    get edit_password_reset_path( 'wrong token', email: user.email )
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path( user.reset_token, email: user.email )
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path( user.reset_token ),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path( user.reset_token ),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path( user.reset_token ),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
