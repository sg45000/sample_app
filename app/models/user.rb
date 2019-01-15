class User < ApplicationRecord
  attr_accessor :remenber_token
  before_save { email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true


  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remenber
    self.remenber_token = User.new_token
    update_attribute(:remenber_digest,User.digest(remenber_token))
  end
  def authenticated?(remenber_token)
    return false if remenber_digest.nil?
    BCrypt::Password.new(remenber_digest).is_password?(remenber_token)
  end
  def forget
    update_attribute(:remenber_digest, nil)
  end
end
