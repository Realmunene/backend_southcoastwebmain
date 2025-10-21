# app/models/admin.rb
class Admin < ApplicationRecord
  has_secure_password

  # ✅ Delay enum definition until table and column exist
  Rails.application.config.to_prepare do
    begin
      if ActiveRecord::Base.connection.data_source_exists?('admins') &&
         ActiveRecord::Base.connection.column_exists?(:admins, :role)
        Admin.enum role: { super_admin: 0, admin: 1 }
      end
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
      # DB not ready yet, skip enum
    end
  end

  # ✅ Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :strong_password
  validate :single_super_admin, if: -> { role == "super_admin" rescue false }

  # ✅ Ensure only one super_admin exists
  def single_super_admin
    return unless column_names.include?("role") rescue false
    if Admin.where(role: 0).where.not(id: id).exists?
      errors.add(:role, "There can only be one Super Admin in the system.")
    end
  end

  # ✅ Helper method
  def super_admin?
    role == "super_admin" rescue false
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
