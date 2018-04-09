class AddDetailToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :telephone, :string
    add_reference :users, :department, foreign_key: true
    add_reference :users, :division, foreign_key: true
    add_reference :users, :sector_city, foreign_key: true
    add_reference :users, :city, foreign_key: true
    add_reference :users, :office, foreign_key: true
  end
end
