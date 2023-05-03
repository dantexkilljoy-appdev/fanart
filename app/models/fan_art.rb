# == Schema Information
#
# Table name: fan_arts
#
#  id           :integer          not null, primary key
#  photos_count :integer
#  topic        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
class FanArt < ApplicationRecord
  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })
  has_many(:photos, { :class_name => "Photo", :foreign_key => "fan_art_id", :dependent => :nullify })
end
