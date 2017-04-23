class ChangeAmountToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :forecasts, :amount, :decimal
  end
end
