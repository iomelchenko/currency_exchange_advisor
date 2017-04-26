require 'rails_helper.rb'

describe ForecastLoader do
  let(:user) { create :user }
  let(:base_currency) { Currency.find(840) }
  let(:target_currency) { Currency.find(985) }

  let(:forecast) do
    create(:forecast,
           base_currency_id:   base_currency.id,
           target_currency_id: target_currency.id,
           user:               user)
  end

  let(:date_range) { (Date.today - 250.weeks)..Date.today }
  let(:forecast_rates) { generate_forecasts_rates(date_range) }
  let(:load_rates) { described_class.new(forecast, forecast_rates).perform }

  it 'should load all forecast rates' do
    expect { load_rates }.to change(RateForecast, :count).by(date_range.count)
  end

  it 'should starts with proper financial week number' do
    load_rates
    first_forecast_week_number = RateForecast.where(forecast: forecast)
                                             .first.week_number
    first_week_number = Date.today.cweek

    expect(first_forecast_week_number).to eql(first_week_number)
  end

  it 'should ends with proper financial week number' do
    load_rates
    last_forecast_week_number = RateForecast.where(forecast: forecast)
                                            .last.week_number
    last_week_number = (Date.today + date_range.count.days).cweek

    expect(last_forecast_week_number).to eql(last_week_number)
  end
end
