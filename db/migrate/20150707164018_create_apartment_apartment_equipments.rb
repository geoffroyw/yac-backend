class CreateApartmentApartmentEquipments < ActiveRecord::Migration
  def change
    create_table :apartment_apartment_equipments do |t|
      t.integer :apartment_id, index: true
      t.integer :equipment_id, index: true

      t.timestamps null: false
    end
  end
end
