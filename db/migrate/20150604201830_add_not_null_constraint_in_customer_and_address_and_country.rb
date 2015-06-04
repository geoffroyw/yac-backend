class AddNotNullConstraintInCustomerAndAddressAndCountry < ActiveRecord::Migration
  def change
    change_column_null :customers, :first_name, false
    change_column_null :customers, :last_name, false
    change_column_null :addresses, :customer_id, false
    change_column_null :addresses, :address, false
    change_column_null :addresses, :postal_code, false
    change_column_null :addresses, :city, false
    change_column_null :addresses, :country_id, false
  end
end
