class AddOrganizationIdToPeriod < ActiveRecord::Migration
  def change
    add_column :pricing_periods, :organization_id, :integer
    add_index :pricing_periods, :organization_id
  end
end
