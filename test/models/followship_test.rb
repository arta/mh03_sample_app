require 'test_helper'

class FollowshipTest < ActiveSupport::TestCase
  def setup
    @duplicate_followship = Followship.new( follower: users( :michael ),
                                            followee: users( :archer ) )
    @followship = Followship.new( follower: users( :michael ),
                                  followee: users( :malory ) )
  end

  test "duplicate should be invalid" do
    assert @duplicate_followship.invalid?
    assert_not @duplicate_followship.save
  end

  test "should be valid" do
    assert @followship.valid?
    assert @followship.save
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
