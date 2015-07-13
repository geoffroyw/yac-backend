class AddOrganizationIdToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :organization_id, :integer
    add_index :rentals, :organization_id
  end
end
