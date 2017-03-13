require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin         = users( :michael )
    @non_admin     = users( :archer )
    @not_activated = users( :lana )
  end

  test "index as admin with pagination and delete links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.where( activated:true ).page( 1 )
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path( user ), text: user.name
      unless user == @admin # admin's own listing doesn't show delete link
        assert_select 'a[href=?]', user_path( user ), text: 'delete'
      end
    end
    # also used in user_test :: associated microposts should be destroyed
    assert_difference 'User.count', -1 do
      delete user_path( @non_admin )
    end
  end

  test "index as non-admin" do
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  test 'index lists only activated users' do
    log_in_as @non_admin
    get users_path
    all_users = User.all.count
    assert_equal all_users, 34
    activated_users = assigns( :users )
    assert_equal activated_users.count, 33 # 2-27-17 dev't note on why this works 
    first_page_of_all_users = User.page( 1 )
    assert first_page_of_all_users.pluck( :name ).include?( @not_activated.name )
    first_page_of_users = User.where( activated:true ).page( 1 )
    assert_not first_page_of_users.pluck( :name ).include?( @not_activated.name )
    first_page_of_users.each do |user|
      get user_path( user )
      assert_template 'users/show'
    end
  end

  test 'attempt to show not activated user redirects to root_path' do
    get user_path( @not_activated )
    assert_redirected_to root_path
  end
end
