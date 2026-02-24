# == Schema Information
#
# Table name: photos
#
#  id          :bigint           not null, primary key
#  caption     :string
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  activity_id :integer
#
class Photo < ApplicationRecord
  belongs_to :activity
  mount_uploader :image, ImageUploader # Use your actual uploader class name
end
