class RenameLastDate < ActiveRecord::Migration[5.0]
  def change
    rename_column :forecasts, :last_date, :term_in_weeks
  end
end
