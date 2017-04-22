class AddForecastAmount < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :amount, :integer
  end
end
