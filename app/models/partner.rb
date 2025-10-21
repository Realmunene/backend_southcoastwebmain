class Partner < ApplicationRecord
  has_secure_password  # enables password hashing and authentication

  validates :supplier_type, :supplier_name, :mobile, :email, :contact_person, :city, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
end
