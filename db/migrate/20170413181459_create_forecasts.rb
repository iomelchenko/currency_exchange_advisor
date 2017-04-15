class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.integer :base_currency_id, index: true
      t.integer :target_currency_id, index: true
      t.integer :last_date, index: true
      t.timestamps
    end
  end
end
