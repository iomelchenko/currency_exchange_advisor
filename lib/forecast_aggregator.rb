class ForecastAggregator
  attr_accessor :forecast

  def initialize(forecast)
    @forecast = forecast
  end

  def perform
    aggregate_data
  end

  private

  def aggregate_data
    RateForecast.where(forecast: forecast).group_by_year_week
                .select_with_rank.order_by_year_week
  end
end
