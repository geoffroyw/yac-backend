class RemoveApartmentIdFromEquipment < ActiveRecord::Migration
  def change
    remove_column :apartment_equipment, :apartment_id
  end
end
