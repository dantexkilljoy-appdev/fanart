# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string
#  own_photos_count :integer
#  password_digest  :string
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  validates(:username, { :presence => true })
  validates(:username, { :uniqueness => true })

  has_secure_password

  has_many(:own_photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })
  has_many(:likes, { :class_name => "Like", :foreign_key => "user_id", :dependent => :destroy })
  has_many(:fan_arts, { :class_name => "FanArt", :foreign_key => "user_id", :dependent => :destroy })
end
