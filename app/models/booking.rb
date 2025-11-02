# app/models/booking.rb
class Booking < ApplicationRecord
  # 👇 Association
  belongs_to :user

  # 👇 Validations
  validates :nationality, :room_type, :check_in, :check_out, :adults, :children, presence: true
  validates :adults, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validates :children, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }
  validate :check_out_after_check_in

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?
    errors.add(:check_out, "must be after check_in") if check_out < check_in
  end
end