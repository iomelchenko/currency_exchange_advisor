class ForecastDecorator < Draper::Decorator
  decorates_finders

  def chart_name
    "#{Currency.find(object.base_currency_id).name} - #{Currency.find(object.target_currency_id).name}"
  end

  def currency_selection
    Currency.all.map { |cur| [cur.name, cur.id] }
  end
end
