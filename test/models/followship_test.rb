require 'test_helper'

class FollowshipTest < ActiveSupport::TestCase
  def setup
    @followship = Followship.new( follower: users( :michael ),
                                  followee: users( :archer ) )
  end

  test "should be valid" do
    assert @followship.valid?
  end

  test "should require a follower" do
    @followship.follower = nil
    assert @followship.invalid?
  end

  test "should require a followee" do
    @followship.followee = nil
    assert @followship.invalid?
  end
end
