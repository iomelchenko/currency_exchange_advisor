class HistoricalCurrencyRate < ApplicationRecord
  def self.hist_currency_rates(currency_id, period)
    where(currency_id: currency_id).order('date DESC')
                                   .limit(period).map(&:rate).reverse
  end
end
