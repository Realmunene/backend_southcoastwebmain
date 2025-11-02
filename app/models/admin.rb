# app/models/admin.rb
class Admin < ApplicationRecord
  has_secure_password

  # ✅ Optional enum if needed later
  # enum role: { super_admin: 0, admin: 1 }, _prefix: true

  # ✅ Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }
  validate :strong_password
  validate :single_super_admin, if: -> { role.present? && role.to_i == 0 }

  # ✅ Automatically set default role to 'admin' (1)
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= 1
  end

  # ✅ Ensure only one super_admin exists
  def single_super_admin
    return unless column_names.include?("role")
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
      errors.add(:password, "must include upper, lower, digit, and special character")
    end
  end
end
