module RatesHelper
  def generate_currency_rates(currencies)
    currencies.map do |curr|
      { iso_code: curr.name, rate: rand(1.0..10.0).round(4) }
    end
  end

  def generate_historical_rates(currency_rates, date_range)
    hist_rates = []
    date_range.each do |day|
      currency_rates.each { |curr| hist_rates << curr.merge(date: day) }
    end

    hist_rates
  end

  def generate_historical_currency_rates(currency_rates, date_range)
    date_range.each do |day|
      currency_rates.each do |curr|
        create(:historical_currency_rate,
               date: day.to_time.to_i,
               currency_id: Currency.find_by_name(curr[:iso_code]).id,
               rate: curr[:rate])
      end
    end
  end

  def generate_forecasts_rates(date_range)
    rates = []
    1.upto(date_range.count) do
      rates << rand(1.0..10.0).round(4)
    end

    rates
  end

  def load_forecast_rates(forecast, forecast_rates)
    ForecastLoader.new(forecast, forecast_rates).perform
    RateForecast.all
  end
end
