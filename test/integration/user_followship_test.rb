require 'test_helper'

class UserFollowshipTest < ActionDispatch::IntegrationTest

  def setup
    @user  = users( :michael )
    @other = users( :malory )
    log_in_as( @user )
  end

  test "following page" do
    get followees_user_path( @user )
    assert_not @user.followees.empty?
    # Gotcha: if @user.followees.empty? were true, not a single assert_select 
    # would execute in the loop, leading the tests to pass and thereby give us 
    # a false sense of security.
    assert_match @user.followees.count.to_s, response.body
    @user.followees.each do |user|
      assert_select "a[href=?]", user_path( user )
    end
  end

  test "followers page" do
    get followers_user_path( @user )
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path( user )
    end
  end

  test "should follow a user the standard way" do
    assert_difference '@user.followees.count', 1 do
      post followships_path, params: { followee_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.followees.count', 1 do
      post followships_path, params: { followee_id: @other.id }, xhr: true
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow( @other )
    followship = @user.outfollowships.find_by( followee_id: @other.id )
    assert_difference '@user.followees.count', -1 do
      delete followship_path( followship )
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow( @other )
    followship = @user.outfollowships.find_by( followee_id: @other.id )
    assert_difference '@user.followees.count', -1 do
      delete followship_path( followship ), xhr: true
    end
  end
end
