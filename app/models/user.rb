class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

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
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
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

  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest( activation_token )
    end
end
