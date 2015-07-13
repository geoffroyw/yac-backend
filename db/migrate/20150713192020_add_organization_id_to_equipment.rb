class AddOrganizationIdToEquipment < ActiveRecord::Migration
  def change
    add_column :apartment_equipment, :organization_id, :integer
    add_index :apartment_equipment, :organization_id
  end
end
