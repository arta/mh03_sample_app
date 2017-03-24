require 'test_helper'

class FollowshipsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference 'Followship.count' do
      post followships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Followship.count' do
      delete followship_path( followships( :one ) )
    end
    assert_redirected_to login_url
  end
end
