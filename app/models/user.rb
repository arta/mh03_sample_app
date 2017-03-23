class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship',
                                  foreign_key: :follower_id,
                                  dependent:   :destroy
  has_many :followed, through: :active_relationships
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: :followed_id,
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  before_create :create_activation_digest
  before_save   :downcase_email

  class << self
    # Returns the hash digest of the given string.
    def digest( string )
      cost = ActiveModel::SecurePassword.min_cost ? 
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create( string, cost: cost )
    end
    
    # Returns a random secure token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def email_activation_link
    UserMailer.account_activation( self ).deliver_now
  end

  def activate
    update( activated:true, activated_at:Time.zone.now )
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest( remember_token )
  end
  
  def authenticated?( attribute, token )
    digest = send( "#{attribute}_digest" )
    return false if digest.blank?
    BCrypt::Password.new( digest ) == token
  end
  
  def forget
    update_attribute :remember_digest, nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update( reset_digest: User.digest( reset_token ), reset_at: Time.zone.now )
  end

  def email_password_reset_link
    UserMailer.password_reset( self ).deliver_now
  end

  def password_reset_expired?
    reset_at < 2.hours.ago # read as: "reset earlier than 2 hours ago"
  end

  def feed
    # a proto-feed:
    microposts
  end

  def following?( other_user )
    followed.include? other_user
  end

  def followed_by?( other_user )
    followers.include? other_user
  end

  def follow( other_user )
    followed << other_user
  end

  def unfollow( other_user )
    followed.delete other_user
  end

  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest( activation_token )
    end
end
