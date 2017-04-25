class ForecastLoader
  attr_accessor :forecast, :forecast_rates, :start_date

  def initialize(forecast, forecast_rates)
    @forecast       = forecast
    @forecast_rates = forecast_rates
    @start_date     = (Time.now.to_date.beginning_of_day + 1.day).to_time.to_i
  end

  def perform
    date = start_date
    RateForecast.bulk_insert do |worker|
      forecast_rates.each do |rate|
        build_worker(worker, date, rate)
        date += 86_400
      end
    end
    true
  end

  private

  def build_worker(worker, date, rate)
    worker.add(forecast_id: forecast.id,
               date:        date,
               rate:        rate,
               week_number: Time.at(date).to_date.cweek,
               year:        Time.at(date).to_date.cwyear)
  end
end
