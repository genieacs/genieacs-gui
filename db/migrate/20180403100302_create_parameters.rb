class CreateParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :parameters do |t|
      t.references :device, index: true
      t.json :parameters
      t.timestamps
    end
  end
end
