class ForecastDecorator < ApplicationDecorator
  delegate_all

  def target_currency_name
    "#{Currency.find(target_currency_id).name}"
  end

  def base_amount
    "#{amount.round(2)} #{base_curr_name}"
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

  def year_with_week
    Time.at(object.date).strftime('%Y')
  end
end
