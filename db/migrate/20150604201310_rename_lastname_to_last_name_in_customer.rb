class RenameLastnameToLastNameInCustomer < ActiveRecord::Migration
  def change
    rename_column :customers, :lastname, :last_name
  end
end
