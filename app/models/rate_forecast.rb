# == Schema Information
#
# Table name: rate_forecasts
#
#  id          :integer          not null, primary key
#  forecast_id :integer
#  date        :integer
#  rate        :decimal(, )
#  week_number :integer
#  year        :integer
#

class RateForecast < ApplicationRecord
  belongs_to :forecast

  scope :group_by_year_week, (-> { group(<<-SQL) })
    rate_forecasts.year, rate_forecasts.week_number
    SQL

  scope :select_with_rank, (-> { select(<<-SQL) })
    rate_forecasts.year,
    rate_forecasts.week_number,
    MAX(rate) AS max_rate,
    RANK() OVER(ORDER BY MAX(rate) DESC) AS rank
    SQL

  scope :order_by_year_week, (-> { order('year, week_number') })

  class << self
    def build_chart_object(forecast)
      forecast_rates = where(forecast_id: forecast.id).order(:date)
      rates = fetch_rates(forecast_rates, forecast)

      [{ name:                forecast.target_currency_name,
         point_start:         forecast_rates.first.date * 1000,
         data:                rates,
         point_interval_unit: 'day' }]
    end

    def fetch_rates(forecast_rates, forecast)
      rates = []

      forecast_rates.each do |rate|
        rates << (rate.rate.to_f * forecast.amount.to_f).round(2)
      end

      rates
    end
  end
end
