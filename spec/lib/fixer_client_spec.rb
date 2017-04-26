require 'rails_helper.rb'

describe FixerClient do
  let(:currencies_without_base) { Currency.where.not(id: 978) }

  let(:currency_rates) do
    generate_currency_rates(currencies_without_base)
  end

  let(:current_rates) do
    currency_rates.map { |curr| curr.merge(date: Date.today) }
  end

  let(:date_range) { (Date.today - 10)..Date.today }

  let(:historical_rates) do
    generate_historical_rates(currency_rates, date_range)
  end

  before do
    allow(Fixer::Feed).to receive(:new).with(:current)
      .and_return(current_rates)

    allow(Fixer::Feed).to receive(:new).with(:historical)
      .and_return(historical_rates)
  end

  describe 'load_currency_rates' do
    it 'should loads rates from last date' do
      expect do
        described_class.new(:current).load_currency_rates
      end.to change(HistoricalCurrencyRate, :count).by(Currency.count)
    end

    it 'should loads historical rates' do
      expect do
        described_class.new(:historical).load_currency_rates
      end.to change(HistoricalCurrencyRate, :count)
        .by(Currency.count * date_range.count)
    end
  end

  describe 'load_currency_rates_if_needed' do
    before do
      generate_historical_currency_rates(currency_rates, date_range)
    end

    it 'should loads rates from last date' do
      HistoricalCurrencyRate.where(date: Date.today.to_time.to_i)
                            .destroy_all
      described_class.new(:historical).load_currency_rates_if_needed
      expect(HistoricalCurrencyRate.last.date).to eql Date.today.to_time.to_i
    end

    it 'should not loads rates from last date' do
      expect do
        described_class.new(:current).load_currency_rates_if_needed
      end.not_to change(HistoricalCurrencyRate, :count)
    end
  end
end
