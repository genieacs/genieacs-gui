class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :code
      t.string :name
      t.references :department, foreign_key: true
      t.references :division, foreign_key: true
      t.references :sector_city, foreign_key: true

      t.timestamps
    end
  end
end
