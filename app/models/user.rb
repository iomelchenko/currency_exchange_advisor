class User < ApplicationRecord
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  has_many :forecasts, dependent: :destroy

  validate :validate_username
  validates_uniqueness_of :username

  def validate_username
    User.where(email: username).exists? && errors.add(:username, :invalid)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login)).present?
      where(conditions.to_h)
        .where(['lower(username) = :value OR lower(email) = :value',
                { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
