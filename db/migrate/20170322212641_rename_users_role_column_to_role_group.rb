class RenameUsersRoleColumnToRoleGroup < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :role, :role_group
  end
end
