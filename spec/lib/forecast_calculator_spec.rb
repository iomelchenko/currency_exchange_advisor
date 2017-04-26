require 'rails_helper.rb'

describe ForecastCalculator do
  let(:user) { create :user }
  let(:base_currency) { Currency.find(840) }
  let(:target_currency) { Currency.find(985) }

  let(:forecast) do
    create(:forecast,
           base_currency_id:   base_currency.id,
           target_currency_id: target_currency.id,
           user:            user)
  end

  let(:date_range) { (Date.today - 7.weeks)..Date.today }

  let(:currency_rates) do
    generate_currency_rates([base_currency, target_currency])
  end

  let!(:historical_currency_rates) do
    generate_historical_currency_rates(currency_rates, date_range)
  end

  it 'should calculate forecast rates for forecast period' do
    forecast_rates = described_class.new(forecast).perform
    expect(forecast_rates.count).to eql(date_range.count - 1)
  end
end
