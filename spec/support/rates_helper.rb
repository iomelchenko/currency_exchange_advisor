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

  def find_week_with_rank(rank, loaded_rates)
    sorted_rates = loaded_rates.group(:week_number)
                               .select('MAX(rate) as rate, week_number')
                               .order('MAX(rate)').map(&:week_number)
                               .uniq.reverse

    sorted_rates[rank - 1]
  end

  def sort_aggregated_data(aggregated_data)
    aggregated_data.order(:year, :week_number)
                   .map { |rate| { rate.week_number.to_s => rate.year } }
  end
end
