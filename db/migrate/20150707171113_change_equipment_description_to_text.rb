class ChangeEquipmentDescriptionToText < ActiveRecord::Migration
  def change
    change_column :apartment_equipment, :description, :text
  end
end
