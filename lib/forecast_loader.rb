class ForecastLoader
  attr_accessor :forecast, :forecast_rates, :start_date

  def initialize(forecast, forecast_rates)
    @forecast       = forecast
    @forecast_rates = forecast_rates
    @start_date     = (Time.now.to_date + 1.day).to_time.to_i
  end

  def perform
    date = start_date
    RateForecast.bulk_insert do |worker|
      forecast_rates.each do |rate|
        worker.add(forecast_id: forecast.id,
                   date:        date,
                   rate:        rate)
        date += 86400
      end
    end
    true
  end
end
