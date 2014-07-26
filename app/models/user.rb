class User < ActiveRecord::Base
  before_save :encrypt_password

  attr_accessor :password

  def self.authenticate(email, password)
    user = User.where(email: email).first
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
