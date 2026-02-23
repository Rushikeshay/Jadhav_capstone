# == Schema Information
#
# Table name: trips
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Trip < ApplicationRecord
  has_many  :memberships, class_name: "Membership", foreign_key: "trip_id", dependent: :destroy
  has_many  :days, class_name: "Day", foreign_key: "trip_id", dependent: :destroy
end
