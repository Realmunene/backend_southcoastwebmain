class AddRoleAndNameToAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :admins, :role, :string, default: 'admin'
    add_column :admins, :name, :string
    
    # Update existing admins
    Admin.reset_column_information
      Admin.find_each do |admin|
        admin.update!(name: admin.email.split('@').first, role: 'admin')
      end
    end
  end
end
