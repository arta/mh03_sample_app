require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new name:'Example User', email:'user@example.com',
                     password:'foobar', password_confirmation:'foobar' 
  end

  test "should be valid" do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert @user.invalid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert @user.invalid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert @user.invalid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert @user.invalid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w( user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn )
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end  

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert @user.invalid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert duplicate_user.invalid?
  end
  
  test 'email address should be saved downcased' do
    mixcase_email = 'My.Email@server.us'
    @user.email = mixcase_email
    @user.save
    assert_equal mixcase_email.downcase, @user.reload.email
  end

  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert @user.invalid?
  end

  test 'password should have minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert @user.invalid?
  end
  
  test 'authenticated? should return false when remember_digest is blank' do
    assert_not @user.authenticated?( :remember, 'irrelevant cookie token' )
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create! content: "Lorem ipsum"
    # also used in users_index_test :: index as admin with pagination and ...
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    lana   = users( :lana )
    archer = users( :archer )
    assert_not lana.following?( archer )
    assert_not lana.followed?( archer )
    lana.follow( archer )
    assert lana.following?( archer )
    assert lana.followed?( archer )
    assert archer.followed_by?( lana )
    lana.unfollow( archer )
    assert_not lana.following?( archer )
  end

  test "feed should have the right posts" do
    michael = users( :michael )
    lana    = users( :lana )
    malory  = users( :malory )
    # Micropoosts by a followee
    lana.microposts.each do |lanas_micropost|
      assert michael.feed.include?( lanas_micropost )
    end
    # Micropoosts by self
    michael.microposts.each do |own_micropost|
      assert michael.feed.include?( own_micropost )
    end
    # Micropoosts by a non-followee
    malory.microposts.each do |nonfollowees_micropost|
      assert_not michael.feed.include?( nonfollowees_micropost )
    end
  end
end
