class AddRoleAndNameToAdmins < ActiveRecord::Migration[7.0]
  def change
    uadd_column :admins, :role, :integer, default: 0 unless column_exists?(:admins, :role)
    add_column :admins, :name, :string unless column_exists?(:admins, :name)
    end

    unless column_exists?(:admins, :name)
      add_column :admins, :name, :string
    end

    # ✅ Use plain SQL instead of loading the model to avoid enum error
    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE admins
          SET role = 0,
              name = SUBSTRING(email, 1, POSITION('@' IN email) - 1)
          WHERE name IS NULL OR role IS NULL;
        SQL
      end
    end
  end
end
