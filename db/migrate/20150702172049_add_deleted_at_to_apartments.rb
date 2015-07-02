class AddDeletedAtToApartments < ActiveRecord::Migration
  def change
    add_column :apartment_apartments, :deleted_at, :datetime
    add_index :apartment_apartments, :deleted_at
  end
end
