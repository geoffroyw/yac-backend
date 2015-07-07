class CreateApartmentEquipment < ActiveRecord::Migration
  def change
    create_table :apartment_equipment do |t|
      t.integer :apartment_id, index: true
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
