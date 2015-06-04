class RenameFirstnameToFirstNameInCustomer < ActiveRecord::Migration
  def change
    rename_column :customers, :firstname, :first_name
  end
end
