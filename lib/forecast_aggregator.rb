class ForecastAggregator
  attr_accessor :forecast

  def initialize(forecast)
    @forecast = forecast
  end

  def perform
    aggregate_data
  end

  def aggregate_data
    RateForecast.where(forecast: forecast).
      group("rate_forecasts.year, rate_forecasts.week_number").
      select("rate_forecasts.year, rate_forecasts.week_number, avg(rate) AS avg_rate, RANK() OVER(ORDER BY avg(rate) DESC) AS rank").
      order("week_number")
  end
end
