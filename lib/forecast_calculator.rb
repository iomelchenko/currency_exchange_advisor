class ForecastCalculator
  attr_accessor :forecast

  def initialize(forecast)
    @forecast = forecast
  end

  def perform
    create_forecast(historical_cross_course_rates).
      ts.map {|rate| rate.to_f}.first(forecast_period)
  end

  def forecast_period
    @forecast_period ||= @forecast.term_in_weeks * 7
  end

  def historical_period
    forecast_period > 365 ? forecast_period : 365
  end

  def create_forecast(ts)
    timeseries = ts.to_ts
    Statsample::TimeSeries::ARIMA.ks(timeseries, 1, 0, 0) # (1,0,0) - autoregression model
  end

  def historical_cross_course_rates
    rate = []
    0.upto(historical_base_currency_rates.size - 1).each do |idx|
      rate << historical_target_currency_rates[idx] / historical_base_currency_rates[idx]
    end

    rate
  end

  def historical_base_currency_rates
    @_hist_base_curr_rates ||= HistoricalCurrencyRate.
      historical_currency_rates(@forecast.base_currency_id, historical_period)
  end

  def historical_target_currency_rates
    @_hist_target_curr_rates ||= HistoricalCurrencyRate.
      historical_currency_rates(@forecast.target_currency_id, historical_period)
  end
end
