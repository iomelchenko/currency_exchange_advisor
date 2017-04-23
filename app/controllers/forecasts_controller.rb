class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:edit, :update, :destroy, :fetch_forecast_rates]
  before_action :update_rates, only: [:update, :create]

  def index
    @forecasts = Forecast.all.order('id DESC').
      with_currency.decorate
  end

  def edit
    @aggregarted_forecast = ForecastAggregator.new(@forecast).perform.decorate
  end

  def new
    @forecast = Forecast.new.decorate
  end

  def create
    @forecast = Forecast.new(forecast_params)

    if @forecast.save_forecast
      redirect_to edit_forecast_path(@forecast), notice: 'Forecast was successfully created.'
    else
      render :new
    end
  end

  def update
    @forecast.assign_attributes(forecast_params)

    if @forecast.save_forecast
      redirect_to edit_forecast_path(@forecast), notice: 'Forecast was successfully updated.'
    else
      render :edit
    end
  end

  def fetch_forecast_rates
    forecast_rates = RateForecast.build_forecasts_object(@forecast)
    render json: forecast_rates
  end

  def destroy
    @forecast.remove_with_rates
    redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.'
  end

  private

  def forecast_params
    params.require(:forecast).permit(:base_currency_id, :target_currency_id, :term_in_weeks, :amount)
  end

  def set_forecast
    @forecast = Forecast.find(params[:id]).decorate
  end

  def update_rates
    FixerClient.new.load_currency_rates_if_needed
  end
end
