require 'rails_helper.rb'

describe RateForecast do
  describe 'model associations' do
    it { should belong_to(:forecast) }
  end

  describe 'build_chart_object' do
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
    let!(:loaded_rates) { load_forecast_rates(forecast, forecast_rates) }
    let(:build_chart_object) do
      described_class.build_chart_object(forecast.decorate)
    end

    it 'should build object with proper count of rates' do
      expect(build_chart_object[0][:data].count).to eql(date_range.count)
    end

    it 'should build object with target_currency_name' do
      expect(build_chart_object[0][:name]).to eql(target_currency.name)
    end

    it 'should build object with proper start date' do
      expect(build_chart_object[0][:point_start])
        .to eql(loaded_rates.first.date * 1000)
    end
  end
end
