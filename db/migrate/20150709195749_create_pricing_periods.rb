class CreatePricingPeriods < ActiveRecord::Migration
  def change
    create_table :pricing_periods do |t|
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps null: false
    end
  end
end
