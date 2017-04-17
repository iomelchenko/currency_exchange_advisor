class FixerClient
  attr_accessor :load_type

  def initialize(load_type = :current)
    @load_type = load_type
  end

  def load_currency_rates
    data = Fixer::Feed.new(load_type)
    HistoricalCurrencyRate.delete_all
    HistoricalCurrencyRate.bulk_insert do |worker|
      data.each do |rate|
        if (currency_id = currency_dictionary["#{rate[:iso_code]}"]).present?
          worker.add(currency_id: currency_id,
                     date:        rate[:date].to_time.to_i,
                     rate:        rate[:rate])
        end
      end
    end
  end

  def currency_dictionary
    Currency.convert_to_hash
  end
end
