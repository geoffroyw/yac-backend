class AddCustomerIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :customer_id, :integer, null: false
  end
end
