class User < ActiveRecord::Base
  before_save :encrypt_password

  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessor :password, :password_confirmation

  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_FORMAT }
  validates :password, confirmation: true, presence: true, on: :create,
                       length: { in: 4..128 }
  validates :password_confirmation, :name, :surname, presence: true

  has_many :messages
  has_many :replies
  has_one :yacht

  def self.authenticate!(email, password)
    user = User.where(email: email).first
    return nil if user.nil?
    bcrypted_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    user && user.password_hash == bcrypted_hash ? user : nil
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
