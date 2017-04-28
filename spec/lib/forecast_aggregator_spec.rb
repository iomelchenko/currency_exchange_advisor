require 'rails_helper.rb'

describe ForecastAggregator do
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
  let(:aggregated_data) { described_class.new(forecast).perform }
  let(:rank_1_week) { find_week_with_rank(1, loaded_rates) }
  let(:rank_2_week) { find_week_with_rank(2, loaded_rates) }
  let(:rank_3_week) { find_week_with_rank(3, loaded_rates) }

  context 'ranking' do
    it 'should return first rank for proper week' do
      expect(aggregated_data.find { |rate| rate[:rank] == 1 }.week_number)
        .to eql rank_1_week
    end

    it 'should return first rank for proper week' do
      expect(aggregated_data.find { |rate| rate[:rank] == 2 }.week_number)
        .to eql rank_2_week
    end

    it 'should return third rank for proper week' do
      expect(aggregated_data.find { |rate| rate[:rank] == 3 }.week_number)
        .to eql rank_3_week
    end
  end

  context 'sorting' do
    let(:weeks_with_years) do
      aggregated_data.map { |rate| { rate.week_number.to_s => rate.year } }
    end

    it 'should be sotrted by weeks and years' do
      expect(weeks_with_years).to eql sort_aggregated_data(aggregated_data)
    end
  end
end
