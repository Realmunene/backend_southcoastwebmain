class User < ApplicationRecord
  has_secure_password

  # 👇 Association
  has_many :bookings, dependent: :destroy

  # 👇 Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :password, length: { minimum: 6 }
end
