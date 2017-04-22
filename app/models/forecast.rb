class Forecast < ApplicationRecord
  has_many :rate_forecasts

  validates_presence_of :base_currency_id, :target_currency_id, :amount, :last_date
  validate :validate_forecast_range

  scope :with_currency, ->(){ joins('INNER JOIN currencies AS base_curr ON base_curr.id = forecasts.base_currency_id').joins('INNER JOIN currencies AS target_curr ON target_curr.id = forecasts.target_currency_id').select("forecasts.id, base_curr.name AS base_curr_name, target_curr.name AS target_curr_name, forecasts.amount, forecasts.created_at, forecasts.last_date") }

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

  def validate_forecast_range
    if last_date > (Time.now.to_date + 250.weeks).to_time.to_i
      errors.add(:last_date, "Period more then 250 weeks")
    end

    if last_date < (Time.now.to_date + 7.days).to_time.to_i
      errors.add(:last_date, "Period less then 1 week")
    end
  end
end
