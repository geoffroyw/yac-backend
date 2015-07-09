class CreatePricingPrices < ActiveRecord::Migration
  def change
    create_table :pricing_prices do |t|
      t.integer :period_id
      t.integer :number_of_night
      t.decimal :amount, precision: 30, scale: 10
      t.integer :currency_id

      t.timestamps null: false
    end
    add_index :pricing_prices, :period_id
    add_index :pricing_prices, :currency_id
  end
end
