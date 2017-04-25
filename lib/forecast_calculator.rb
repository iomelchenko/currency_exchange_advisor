class ForecastCalculator
  attr_accessor :forecast

  def initialize(forecast)
    @forecast = forecast
  end

  def perform
    create_forecast(historical_cross_course_rates)
      .ts.map(&:to_f).first(forecast_period)
  end

  private

  def forecast_period
    @forecast_period ||= @forecast.term_in_weeks * 7
  end

  def hist_period
    forecast_period
  end

  def create_forecast(ts)
    timeseries = ts.to_ts

    # (1,0,0) - autoregression model
    Statsample::TimeSeries::ARIMA.ks(timeseries, 1, 0, 0)
  end

  def historical_cross_course_rates
    rate = []
    0.upto(hist_base_currency_rates.size - 1).each do |idx|
      rate << hist_target_currency_rates[idx] / hist_base_currency_rates[idx]
    end

    rate
  end

  def hist_base_currency_rates
    @b_rates ||= HistoricalCurrencyRate
                 .hist_currency_rates(@forecast.base_currency_id, hist_period)
  end

  def hist_target_currency_rates
    @t_rates ||= HistoricalCurrencyRate
                 .hist_currency_rates(@forecast.target_currency_id, hist_period)
  end
end
