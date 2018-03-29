class AddRoleIdToPermission < ActiveRecord::Migration[5.1]
  def change
    add_reference :permissions, :role, index: true
  end
end
