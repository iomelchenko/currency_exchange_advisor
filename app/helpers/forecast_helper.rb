module ForecastHelper
  def currency_selection
    @_currency_selection ||= Currency.all.
      order(:name).map { |cur| [cur.name, cur.id] }
  end
end
