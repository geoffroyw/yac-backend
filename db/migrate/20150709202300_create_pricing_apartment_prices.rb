class CreatePricingApartmentPrices < ActiveRecord::Migration
  def change
    create_table :pricing_apartment_prices do |t|
      t.integer :apartment_id, index: true
      t.integer :price_id, index: true
      t.timestamps null: false
    end
  end
end
