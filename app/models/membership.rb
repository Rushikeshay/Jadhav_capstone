class Membership < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :trip, required: true, class_name: "Trip", foreign_key: "trip_id"
end
