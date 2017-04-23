module ForecastHelper
  def currency_selection
    @_currency_selection ||= Currency.all.
      order(:name).map { |cur| [cur.name, cur.id] }
  end

  def last_date_to_date(last_date)
    Time.at(last_date).to_date.strftime("%m/%d/%Y") if last_date
  end
end
