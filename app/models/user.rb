class User < ApplicationRecord
  attr_accessor :remenber_token, :activation_token
  before_create :create_activation_digest
  before_save  :downcase_email
  #コールバックには、ブロックで渡すか、
  #メソッド参照(:メソッド名とする。)
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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remenber_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)

    # インスタンスメソッド内なのでself.いらない
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
    #selfはインスタンス自信を表す。
  end

  private
  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
