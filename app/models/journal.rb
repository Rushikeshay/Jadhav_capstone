class Journal < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :day, required: true, class_name: "Day", foreign_key: "day_id"
  belongs_to :best_activity, required: true, class_name: "Activity", foreign_key: "best_activity_id"
end
