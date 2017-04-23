class Forecast < ApplicationRecord
  has_many :rate_forecasts

  validates_presence_of :base_currency_id, :target_currency_id, :amount, :term_in_weeks

  scope :with_currency, ->(){ joins('INNER JOIN currencies AS base_curr ON base_curr.id = forecasts.base_currency_id').joins('INNER JOIN currencies AS target_curr ON target_curr.id = forecasts.target_currency_id').select("forecasts.id, base_curr.name AS base_curr_name, target_curr.name AS target_curr_name, forecasts.amount, forecasts.created_at, forecasts.term_in_weeks") }

  def save_forecast
    Forecast.transaction do
      self.save!
      RateForecast.where(forecast: self).delete_all
      forecast_rates = ForecastCalculator.new(self).perform
      ForecastLoader.new(self, forecast_rates).perform
    end
  rescue ActiveRecord::RecordInvalid => exception
  end

  def remove_with_rates
    Forecast.transaction do
      RateForecast.where(forecast: self).delete_all
      self.delete
    end
  end

  def aggregate
    self.rate_forecasts
  end
end
