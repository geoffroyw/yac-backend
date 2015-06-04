class AddCountryIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :country_id, :integer, null: false
  end
end
