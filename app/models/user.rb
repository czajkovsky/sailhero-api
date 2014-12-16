class User < ActiveRecord::Base
  before_save :encrypt_password
  before_create :generate_activation_token

  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessor :password, :password_confirmation

  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_FORMAT }
  validates :password, confirmation: true, length: { in: 4..128 },
                       presence: true, if: :password
  validates :password_confirmation, presence: true, on: :create
  validates :name, :surname, presence: true
  validates :surname, :name, length: { in: 2..128 }

  has_one :yacht
  has_many :alerts
  belongs_to :region
  has_many :devices
  has_many :messages

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inv_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inv_friends, through: :inv_friendships, source: :user

  mount_uploader :avatar, AvatarUploader

  scope :active, -> { where(active: true) }

  include PgSearch
  pg_search_scope :search, against: [:name, :surname, :email]

  def self.authenticate!(email, password)
    user = User.where(email: email).first
    return nil if user.nil?
    bcrypted_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    user && user.password_hash == bcrypted_hash ? user : nil
  end

  def self.full_search(query)
    return [] if key.nil?
    search(query)
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def activate!
    update_attributes(active: true, activation_token: '')
  end

  def generate_activation_token
    self.activation_token = loop do
      random = Digest::SHA1.hexdigest([Time.now, rand].join)
      break random unless User.exists?(activation_token: random)
    end
  end
end
