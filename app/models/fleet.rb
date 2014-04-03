class Fleet < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :devices
  has_many :memberships
  has_many :users, through: :memberships

  def dispatch_url
    ENV['DISPATCH_URL'] + "/#/#{socket_url}"
  end
end
