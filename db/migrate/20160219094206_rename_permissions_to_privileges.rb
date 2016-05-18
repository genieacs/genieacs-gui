class RenamePermissionsToPrivileges < ActiveRecord::Migration
  def change
    rename_table :permissions, :privileges
  end
end
