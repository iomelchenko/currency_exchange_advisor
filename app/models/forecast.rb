class Forecast < ApplicationRecord
  has_many :rate_forecasts
  belongs_to :user

  validates_presence_of :base_currency_id, :target_currency_id, :amount, :term_in_weeks
  validates_numericality_of :amount

  scope :with_currency, ->(){ joins('INNER JOIN currencies AS base_curr ON base_curr.id = forecasts.base_currency_id').joins('INNER JOIN currencies AS target_curr ON target_curr.id = forecasts.target_currency_id').select("forecasts.id, base_curr.name AS base_curr_name, target_curr.name AS target_curr_name, forecasts.amount, forecasts.updated_at, forecasts.term_in_weeks") }

  scope :for_current_user, ->(user){ where(user: user) }

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
end
