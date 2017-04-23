class AddWeekNumberYear < ActiveRecord::Migration[5.0]
  def change
    add_column :historical_currency_rates, :week_number, :integer, index: true
    add_column :historical_currency_rates, :year, :integer, index: true
    add_column :rate_forecasts, :week_number, :integer, index: true
    add_column :rate_forecasts, :year, :integer, index: true
  end
end
