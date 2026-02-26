# == Schema Information
#
# Table name: days
#
#  id         :bigint           not null, primary key
#  date       :date
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :integer
#
class Day < ApplicationRecord
  belongs_to :trip, required: true, class_name: "Trip", foreign_key: "trip_id"
  has_many  :activities, class_name: "Activity", foreign_key: "day_id", dependent: :destroy
  has_many  :journals, class_name: "Journal", foreign_key: "day_id", dependent: :destroy
end
