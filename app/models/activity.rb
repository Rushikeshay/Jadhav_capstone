class Activity < ApplicationRecord
  belongs_to :day, required: true, class_name: "Day", foreign_key: "day_id"
  has_many  :journals, class_name: "Journal", foreign_key: "best_activity_id", dependent: :destroy
  mount_uploader :picture, ImageUploader
  
  belongs_to :day
end
