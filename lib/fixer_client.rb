class FixerClient
  attr_accessor :load_type

  def initialize(load_type = :current)
    @load_type = load_type
  end

  def load_euro_currency_rates
    data = Fixer::Feed.new(load_type)

    data.each do |rate|
      if (currency_id = currency_dictionary["#{rate[:iso_code]}"]).present?
        HistoricalCurrencyRate.where(currency_id: currency_id, date: rate[:date].to_time.to_i).
          first_or_create(rate: rate[:rate])
      end
    end
  end

  def currency_dictionary
    Currency.convert_to_hash
  end
end
