class AddOrganizationIdToPrice < ActiveRecord::Migration
  def change
    add_column :pricing_prices, :organization_id, :integer
    add_index :pricing_prices, :organization_id
  end
end
