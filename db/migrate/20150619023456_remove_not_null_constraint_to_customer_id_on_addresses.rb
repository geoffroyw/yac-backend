class RemoveNotNullConstraintToCustomerIdOnAddresses < ActiveRecord::Migration
  def change
    change_column_null :addresses, :customer_id, true
  end
end
