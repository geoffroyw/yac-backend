class CreateApartmentApartments < ActiveRecord::Migration
  def change
    create_table :apartment_apartments do |t|
      t.string :name, :null => false
      t.integer :capacity, :null => false
      t.text :description

      t.timestamps null: false
    end
  end
end
