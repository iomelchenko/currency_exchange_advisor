class Forecast < ApplicationRecord
  has_many :rate_forecasts, dependent: :destroy

  scope :with_currency, ->(){ joins('INNER JOIN currencies AS base_curr ON base_curr.id = forecasts.base_currency_id').joins('INNER JOIN currencies AS target_curr ON target_curr.id = forecasts.target_currency_id').select("forecasts.id, base_curr.name AS base_curr_name, target_curr.name AS target_curr_name, forecasts.created_at, forecasts.last_date") }
end
