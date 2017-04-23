class FixerClient
  attr_accessor :load_type

  def initialize(load_type = :current, base_currency = "EUR")
    @load_type = load_type
    @base_currency = base_currency
  end

  def load_currency_rates
    data = fetch_rates
    clear_rates(data)
    data = add_base_currency_data(data)
    insert_rates(data)
  end

  def load_currency_rates_if_needed
    load_currency_rates unless last_rates_loaded?
  end

  def fetch_rates
    Fixer::Feed.new(load_type).sort_by { |rate| rate[:date] }.to_a
  end

  def clear_rates(data)
    HistoricalCurrencyRate.where("date IN (#{loaded_dates(data)})").delete_all
  end

  def add_base_currency_data(data)
    dates = data.map { |rate| rate[:date] }.uniq
    dates.each do |date|
      data << { iso_code: @base_currency, rate: 1.0, date: date }
    end

    data
  end

  def loaded_dates(data)
    data.map { |rate| rate[:date].to_time.to_i }.uniq.join(',')
  end

  def insert_rates(data)
    HistoricalCurrencyRate.bulk_insert do |worker|
      data.each do |rate|
        if (currency_id = currency_dictionary["#{rate[:iso_code]}"]).present?
          worker.add(currency_id: currency_id,
                     date:        rate[:date].to_time.to_i,
                     rate:        rate[:rate],
                     week_number: rate[:date].strftime('%W').to_i,
                     year:        rate[:date].strftime('%Y').to_i)
        end
      end
    end
  end

  def currency_dictionary
    @_currency_dictionary ||= Currency.convert_to_hash
  end

  def last_rates_loaded?
    HistoricalCurrencyRate.last.date == Date.today.to_time.to_i
  end
end
