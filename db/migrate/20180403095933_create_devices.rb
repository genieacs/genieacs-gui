class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :device_id
      t.json :info
      t.datetime :last_inform
      t.timestamps
    end
  end
end
