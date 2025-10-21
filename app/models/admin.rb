# app/models/admin.rb
class Admin < ApplicationRecord
  has_secure_password

  # ✅ Comment out enum for now to avoid loading errors during seeds
  # enum role: { super_admin: 0, admin: 1 }, _prefix: true

  # ✅ Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :strong_password
  validate :single_super_admin, if: -> { role.to_i == 0 rescue false }

  # ✅ Ensure only one super_admin exists
  def single_super_admin
    return unless column_names.include?("role") rescue false
    if Admin.where(role: 0).where.not(id: id).exists?
      errors.add(:role, "There can only be one Super Admin in the system.")
    end
  end

  # ✅ Helper method
  def super_admin?
    role.to_i == 0 rescue false
  end

  private

  # ✅ Strong password policy
  def strong_password
    return if password.blank?

    unless password.match?(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d]).+$/)
      errors.add(:password, "must include upper, lower, digit and special character")
    end
  end
end
