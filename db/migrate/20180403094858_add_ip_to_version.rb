class AddIpToVersion < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :ip, :string
  end
end
