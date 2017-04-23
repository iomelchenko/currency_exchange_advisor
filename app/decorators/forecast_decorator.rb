class ForecastDecorator < Draper::Decorator
  delegate_all

  def chart_name
    "#{Currency.find(target_currency_id).name}"
  end

  def base_amount
    "#{amount} #{base_curr_name}"
  end

  def last_date
    (created_at + (term_in_weeks * 7).days).to_date
  end

  def currency_selection
    @_currency_selection ||= Currency.all.
      order(:name).map { |cur| [cur.name, cur.id] }
  end

  def weeks_selection
    1.upto(250).map { |week| ["#{week} weeks", week] }
  end
end
