# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :integer
#  user_id    :integer
#
class Membership < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :trip, required: true, class_name: "Trip", foreign_key: "trip_id"
end
