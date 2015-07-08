class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :customer_id
      t.integer :apartment_id
      t.date :start_date
      t.date :end_date
      t.integer :number_of_adult
      t.integer :number_of_children
      t.string :state

      t.timestamps null: false
    end
    add_index :rentals, :customer_id
    add_index :rentals, :apartment_id
    add_index :rentals, :start_date
    add_index :rentals, :end_date
  end
end
