# app/controllers/api/v1/admin/admins_controller.rb
class Api::V1::Admin::AdminsController < ApplicationController
  before_action :authorize_admin                                # must be logged in as admin or super_admin
  before_action :authorize_super_admin, only: [:create, :update, :destroy]  # only super_admin can manage admins

  # ✅ List all admins (excluding super admins)
  def index
    admins = Admin.where(role: "admin")
    render json: admins, status: :ok
  end

  # ✅ Create a new admin (super_admin only)
  def create
    admin = Admin.new(admin_params.merge(role: "admin"))
    if admin.save
      render json: { message: "Admin created successfully", admin: admin }, status: :created
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Update admin (super_admin only)
  def update
    admin = Admin.find_by(id: params[:id])
    if admin&.update(admin_params)
      render json: { message: "Admin updated successfully", admin: admin }, status: :ok
    else
      render json: { error: "Admin not found or update failed" }, status: :unprocessable_entity
    end
  end

  # ✅ Delete admin (cannot delete super_admin)
  def destroy
    admin = Admin.find_by(id: params[:id])
    if admin.nil?
      render json: { error: "Admin not found" }, status: :not_found
    elsif admin.super_admin?
      render json: { error: "Cannot delete super_admin" }, status: :forbidden
    else
      admin.destroy
      render json: { message: "Admin deleted successfully" }, status: :ok
    end
  end

  private

  # ✅ Restrict certain actions to super_admin
  def authorize_super_admin
    unless current_admin&.super_admin?
      render json: { error: "Forbidden: Only super_admin can manage admins" }, status: :forbidden
    end
  end

  # ✅ Strong params
  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :name)
  end
end
