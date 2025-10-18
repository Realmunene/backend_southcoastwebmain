# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :user  # required association

  validates :nationality, :room_type, :check_in, :check_out, :guests, presence: true
  validate :check_out_after_check_in

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?
    errors.add(:check_out, "must be after check_in") if check_out < check_in
  end
end
