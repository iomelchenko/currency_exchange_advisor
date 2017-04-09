class CreateHistoricalCurrencyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :historical_currency_rates do |t|
      t.integer :date, index: true
      t.references :currency, index: true
      t.decimal :rate
    end
  end
end
