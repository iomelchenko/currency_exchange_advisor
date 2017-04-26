# == Schema Information
#
# Table name: historical_currency_rates
#
#  id          :integer          not null, primary key
#  date        :integer
#  currency_id :integer
#  rate        :decimal(, )
#  week_number :integer
#  year        :integer
#

class HistoricalCurrencyRate < ApplicationRecord
  belongs_to :currency

  class << self
    def hist_currency_rates(currency_id, period)
      where(currency_id: currency_id).order('date DESC')
                                     .limit(period).map(&:rate).reverse
    end
  end
end
