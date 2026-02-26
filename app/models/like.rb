# == Schema Information
#
# Table name: likes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  activity_id :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_likes_on_user_id_and_activity_id  (user_id,activity_id) UNIQUE
#
class Like < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :activity, class_name: "Activity", foreign_key: "activity_id"
  validates :user_id, uniqueness: { scope: :activity_id }
end
