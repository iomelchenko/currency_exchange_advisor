class CreateRateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :rate_forecasts do |t|
      t.references :forecast, index: true
      t.integer :date, index: true
      t.decimal :rate
    end
  end
end
