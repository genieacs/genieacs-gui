class CreateSectorCities < ActiveRecord::Migration[5.1]
  def change
    create_table :sector_cities do |t|
      t.string :code
      t.string :name
      t.references :department, foreign_key: true
      t.references :division, foreign_key: true

      t.timestamps
    end
  end
end
