class RenamePermissionsToPrivileges < ActiveRecord::Migration[5.1]
  def change
    rename_table :permissions, :privileges
  end
end
