class AddOrganizationIdToApartment < ActiveRecord::Migration
  def change
    add_column :apartment_apartments, :organization_id, :integer
    add_index :apartment_apartments, :organization_id
  end
end
