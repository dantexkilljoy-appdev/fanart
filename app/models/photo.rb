# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_art_id :integer
#  owner_id   :integer
#
class Photo < ApplicationRecord
  belongs_to(:owner, { :required => true, :class_name => "User", :foreign_key => "owner_id", :counter_cache => :own_photos_count })
  has_many(:likes, { :class_name => "Like", :foreign_key => "photo_id", :dependent => :destroy })
  belongs_to(:fan_art, { :required => true, :class_name => "FanArt", :foreign_key => "fan_art_id", :counter_cache => true })

  validates(:owner_id, { :presence => true })
  validates(:image, { :presence => true })
end