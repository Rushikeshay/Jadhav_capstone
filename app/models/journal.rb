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
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :day, class_name: "Day", foreign_key: "day_id"
  
  # Changed: Removed 'required: true' so you can save without picking an activity
  belongs_to :best_activity, class_name: "Activity", foreign_key: "best_activity_id", optional: true

  # Optional: Validations for the other fields
  validates :day_id, presence: true
  validates :user_id, presence: true
end
