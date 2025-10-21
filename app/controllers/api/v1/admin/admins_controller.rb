# app/controllers/api/v1/admin/admins_controller.rb
class Api::V1::Admin::AdminsController < ApplicationController
  before_action :authorize_admin
  before_action :authorize_super_admin, only: [:create, :update, :destroy]

  # ✅ List all admins (excluding super_admin)
  def index
    admins = Admin.where(role: "admin")
    render json: admins, status: :ok
  end

  # ✅ Create a new admin (super_admin only)
  def create
    # Prevent creating another super_admin
    if params[:admin][:role] == "super_admin"
      return render json: { error: "You cannot create another super_admin." }, status: :forbidden
    end

    admin = Admin.new(admin_params.merge(role: "admin"))
    if admin.save
      render json: { message: "Admin created successfully.", admin: admin }, status: :created
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Update an existing admin (super_admin only)
  def update
    admin = Admin.find_by(id: params[:id])
    if admin.nil?
      return render json: { error: "Admin not found." }, status: :not_found
    end

    # Prevent updating the super_admin
    if admin.super_admin?
      return render json: { error: "Super Admin cannot be modified." }, status: :forbidden
    end

    # Prevent role manipulation
    if params[:admin] && params[:admin][:role]
      return render json: { error: "Role updates are not allowed." }, status: :forbidden
    end

    if admin.update(admin_params)
      render json: { message: "Admin updated successfully.", admin: admin }, status: :ok
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Delete an admin (cannot delete super_admin)
  def destroy
    admin = Admin.find_by(id: params[:id])
    if admin.nil?
      return render json: { error: "Admin not found." }, status: :not_found
    end

    if admin.super_admin?
      return render json: { error: "Cann
