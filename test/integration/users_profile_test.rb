require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper # to test `full_title()`

  def setup
    @user = users( :michael )
  end

  test "profile display" do
    get user_path( @user )
    assert_template 'users/show'
    # Possible due to `include ApplicationHelper` above:
    assert_select 'title', full_title( @user.name )
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    # Similar to the assert_match above, but much more specific:
    assert_select 'h3', "#{@user.microposts.count} Microposts"
    assert_select 'div.pagination', count: 1
    @user.microposts.page( 1 ).each do |micropost|
      assert_match micropost.content, response.body
    end
  end  
end
