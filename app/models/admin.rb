class Admin < ApplicationRecord
  has_secure_password

  # ✅ Validation rules
  validates :password, length: { minimum: 8 }
  validate :strong_password
  validates :email, presence: true, uniqueness: true

  private

  # ✅ Custom password strength validation
  def strong_password
    return if password.blank?  

    unless password.match?(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d]).+$/)
      errors.add(:password, "must include upper, lower, digit and special character")
    end
  end
end
