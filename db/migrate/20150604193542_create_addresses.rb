class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :address2
      t.string :postal_code
      t.string :city

      t.timestamps
    end
  end
end
