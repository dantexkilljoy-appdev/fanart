# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_art_id :integer
#  user_id    :integer
#
class Message < ApplicationRecord
  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })
  belongs_to(:fan_art, { :required => true, :class_name => "FanArt", :foreign_key => "fan_art_id" })
end
