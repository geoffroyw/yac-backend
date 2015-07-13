class AddOrganizationIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :organization_id, :integer
    add_index :customers, :organization_id
  end
end
