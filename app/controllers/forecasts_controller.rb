class ForecastsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_forecast, only: %i[edit update destroy fetch_chart_data]
  before_action :update_rates, only: %i[update create]

  def index
    @forecasts = Forecast.for_current_user(current_user)
                         .order('id DESC').with_base_currency
                         .with_target_currency
                         .select_attributes
                         .paginate(page: params[:page], per_page: 10)
                         .decorate
  end

  def edit
    aggregate_forecast
  end

  def new
    @forecast = Forecast.new.decorate
  end

  def create
    @forecast = Forecast.new(forecast_params).decorate

    if forecast_saved?
      redirect_to edit_forecast_path(@forecast),
                  notice: 'Forecast was successfully created.'
    else
      render :new
    end
  end

  def update
    @forecast.assign_attributes(forecast_params)

    if forecast_saved?
      redirect_to edit_forecast_path(@forecast),
                  notice: 'Forecast was successfully updated.'
    else
      aggregate_forecast
      render :edit
    end
  end

  def fetch_chart_data
    forecast_rates = RateForecast.build_forecasts_object(@forecast)
    render json: forecast_rates
  end

  def destroy
    @forecast.remove_with_rates
    redirect_to forecasts_url,
                notice: 'Forecast was successfully destroyed.'
  end

  private

  def forecast_params
    params.require(:forecast)
          .permit(:base_currency_id,
                  :target_currency_id,
                  :term_in_weeks,
                  :amount,
                  :user_id)
          .to_h.merge(user_id: current_user.id)
  end

  def set_forecast
    @forecast = Forecast.for_current_user(current_user)
                        .find(params[:id]).decorate
  end

  def update_rates
    FixerClient.new.load_currency_rates_if_needed
  end

  def aggregate_forecast
    @aggregarted_forecast = ForecastAggregator.new(@forecast).perform.decorate
  end

  def forecast_saved?
    @forecast.save_forecast && @forecast.errors.empty?
  end
end
