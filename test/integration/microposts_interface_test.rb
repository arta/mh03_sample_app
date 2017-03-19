require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as( @user )
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.page( 1 ).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path( first_micropost )
    end
    # Visit different user (no delete links)
    get user_path( users( :archer ) )
    assert_select 'a', text: 'delete', count: 0
  end

  test 'home page aside micropost count' do
    log_in_as @user
    get root_path
    assert_select 'section.user_info'
    assert_match '34 microposts', response.body
    # Delete 1 of 2 microposts
    archer = users( :archer )
    log_in_as archer
    get root_path
    assert_select 'section.user_info > h1', 'Sterling Archer'
    delete micropost_path( archer.microposts.first.id )
    follow_redirect!
    assert_match '1 micropost', response.body
    # Create 1st micropost
    malory = users( :malory )
    log_in_as( malory )
    get root_path
    assert_match "0 microposts", response.body
    malory.microposts.create!( content: "A micropost" )
    get root_path
    assert_match '1 micropost', response.body
  end
end
