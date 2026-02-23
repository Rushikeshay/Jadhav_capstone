class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Direct Associations 
  has_many  :memberships, class_name: "Membership", foreign_key: "user_id", dependent: :destroy
  has_many  :journals, class_name: "Journal", foreign_key: "user_id", dependent: :destroy
  # Indirect Associations
  has_many :trips, through: :memberships, source: :trip
end
