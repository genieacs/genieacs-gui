class AddRoleIdToPermission < ActiveRecord::Migration
  def change
    add_reference :permissions, :role, index: true
  end
end
