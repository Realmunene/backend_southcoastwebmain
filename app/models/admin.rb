class Admin < ApplicationRecord
  has_secure_password

  # ✅ Define roles using enum (super_admin = 0, admin = 1)
  Rails.application.config.to_prepare do
    if ActiveRecord::Base.connection.data_source_exists?('admins') &&
       ActiveRecord::Base.connection.column_exists?(:admins, :role)
      Admin.enum role: { super_admin: 0, admin: 1 }
    end
  end

  # ✅ Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :strong_password

  # ✅ Helper method to check super admin
  def super_admin?
    role == "super_admin" || role == 0
  end

  private

  # ✅ Strong password policy: must include upper, lower, digit & special character
  def strong_password
    return if password.blank?

    unless password.match?(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d]).+$/)
      errors.add(:password, "must include upper, lower, digit and special character")
    end
  end
end
