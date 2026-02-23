# == Schema Information
#
# Table name: journals
#
#  id                     :bigint           not null, primary key
#  ai_generated_questions :text
#  response               :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  best_activity_id       :integer
#  day_id                 :integer
#  user_id                :integer
#
class Journal < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :day, required: true, class_name: "Day", foreign_key: "day_id"
  belongs_to :best_activity, required: true, class_name: "Activity", foreign_key: "best_activity_id"
end
