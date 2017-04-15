class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :edit, :update, :destroy]

  def index
    @forecasts = Forecast.all.order('id DESC').with_currency
  end

  def show
  end

  def new
    @forecast = Forecast.new
  end

  def create

  end

  def create
    @forecast = Forecast.new(forecast_params)

    if @forecast.save
      ForecastCalculator.new(@forecast).perform
      redirect_to forecast_path(@forecast), notice: 'Forecast was successfully created.'
    else
      render :new
    end
  end

  def fetch_forecast_rates
    rates = []
    @forecast = RateForecast.where(forecast_id: params[:id]).order(:date)

    @forecast.limit(100).each do |rate|
      rates.push(rate.rate.to_f)
    end

    @start_date = @forecast.first.date * 1000

    render json: [{name:                'USD',
                   point_start:         @start_date,
                   point_interval_unit: 'day',
                   data:                rates}]
  end

  def destroy
    @forecast.destroy
    redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.'
  end

  private

  def forecast_params
    params.require(:forecast).permit(:base_currency_id, :target_currency_id, :last_date)
  end

  def set_forecast
    @forecast = Forecast.find(params[:id])
  end
end
