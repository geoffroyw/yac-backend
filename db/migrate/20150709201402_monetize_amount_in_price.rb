class MonetizeAmountInPrice < ActiveRecord::Migration
  def change
    remove_column :pricing_prices, :currency_id, :integer, index: true
    remove_column :pricing_prices, :amount, :decimal
    add_monetize :pricing_prices, :amount
  end
end
