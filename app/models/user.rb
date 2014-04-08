class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2, :gplus]
  has_many :devices
  has_many :memberships
  has_many :owned_fleets, foreign_key: "owner_id", class_name: "Fleet"
  has_many :fleets, through: :memberships
  before_save :ensure_authentication_token

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    from_google(access_token.info)
  end

  def self.from_google(data)
    user = User.where(:email => data["email"]).first

    unless user
      user = User.new(
        email: data["email"],
        password: Devise.friendly_token[0,20]
      )
    end

    user.first_name = data["first_name"]
    user.last_name = data["last_name"]
    user.save!
    user
  end

  def self.find_for_gplus(access_token, signed_in_resource=nil)
    from_google(access_token.info)
  end

  def can_dispatch? fleet
    self.memberships.where(fleet: fleet, dispatcher: true).count > 0
  end

  def name
    first_name + " " + last_name
  end

  def device_ids
    return [] unless devices
    devices.pluck(:id)
  end
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
