class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :edit, :update, :destroy, :fetch_forecast_rates]

  def index
    @forecasts = Forecast.all.order('id DESC').with_currency
  end

  def show
  end

  def new
    @forecast = Forecast.new
  end

  def create
    FixerClient.new.load_currency_rates_if_needed

    @forecast = Forecast.new(
      last_date:          Date.strptime(forecast_params[:last_date], '%m/%d/%Y').to_time.to_i,
      base_currency_id:   forecast_params[:base_currency_id],
      target_currency_id: forecast_params[:target_currency_id]
      )

    if @forecast.save_forecast
      redirect_to forecast_path(@forecast), notice: 'Forecast was successfully created.'
    else
      render :new
    end
  end

  def fetch_forecast_rates
    rates = []
    forecast_rates = RateForecast.where(forecast_id: @forecast.id).order(:date)

    forecast_rates.each do |rate|
      rates.push(rate.rate.to_f)
    end

    render json: [{name:                @forecast_decorated.chart_name,
                   point_start:         forecast_rates.first.date * 1000,
                   point_interval_unit: 'day',
                   data:                rates}]
  end

  def destroy
    @forecast.remove_with_rates
    redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.'
  end

  private

  def forecast_params
    params.require(:forecast).permit(:base_currency_id, :target_currency_id, :last_date)
  end

  def set_forecast
    @forecast = Forecast.find(params[:id])
    @forecast_decorated = @forecast.decorate
  end
end
