# == Schema Information
#
# Table name: activities
#
#  id              :bigint           not null, primary key
#  address         :string
#  any_cost        :boolean
#  cost            :integer
#  latitude        :float
#  longitude       :float
#  name            :string
#  notes           :string
#  picture         :string
#  picture_caption :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  day_id          :integer
#
class Activity < ApplicationRecord
  belongs_to :day, required: true, class_name: "Day", foreign_key: "day_id"
  has_many :journals, class_name: "Journal", foreign_key: "best_activity_id", dependent: :destroy
  has_many :photos, dependent: :destroy
  mount_uploader :picture, ImageUploader
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
