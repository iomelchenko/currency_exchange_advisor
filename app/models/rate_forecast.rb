class RateForecast < ApplicationRecord
  belongs_to :forecast

  def self.build_forecasts_object(forecast)
    rates = []
    forecast_rates = where(forecast_id: forecast.id).order(:date)

    forecast_rates.each do |rate|
      rates.push (rate.rate.to_f * forecast.amount).round(3)
    end

    [{ name:                forecast.chart_name,
       point_start:         forecast_rates.first.date * 1000,
       data:                rates,
       point_interval_unit: 'day'
     }]

  end
end
