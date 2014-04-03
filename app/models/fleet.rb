class Fleet < ActiveRecord::Base
  has_many :devices
  belongs_to :owner, class_name: "User"
end
