class AddUserToForecast < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :user_id, :integer, index: true
  end
end
