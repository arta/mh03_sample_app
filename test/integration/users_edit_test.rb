require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users( :michael )
  end
  
  test 'unsuccessful edit' do
    log_in_as @user
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path( @user ), params: { user: { name: '',
                                                email: 'invalid',
                                                password: 'foo',
                                                password_confirmation: 'bar' }}
    assert_response :success # request was processed and responded to properly!
                             # the submitted data had error(s), not the response
    assert_template 'users/edit'
    assert_select 'div.alert', text: 'The form contains 4 errors.'
    assert_select 'div.field_with_errors', count: 8
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    # follow_redirect!
    log_in_as @user
    assert_redirected_to edit_user_path( @user )
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
