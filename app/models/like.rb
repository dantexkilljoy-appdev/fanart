# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_id   :integer
#  user_id    :integer
#
class Like < ApplicationRecord
  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })
  belongs_to(:photo, { :required => true, :class_name => "Photo", :foreign_key => "photo_id" })
end
