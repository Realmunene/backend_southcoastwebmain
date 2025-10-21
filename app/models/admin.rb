class Admin < ApplicationRecord
  has_secure_password

  # ✅ Define roles using enum (super_admin = 0, admin = 1)
  enum role: { super_admin: 0, admin: 1 }

  # ✅ Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :strong_password
  validate :single_super_admin, if: -> { role == "super_admin" }

  # ✅ Custom validation to ensure only one super_admin exists
  def single_super_admin
    if Admin.where(role: :super_admin).where.not(id: id).exists?
      errors.add(:role, "There can only be one Super Admin in the system.")
    end
  end

  # ✅ Helper method to check if the current admin is super_admin
  def super_admin?
    role == "super_admin"
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
