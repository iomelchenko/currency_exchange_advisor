class ForecastDecorator < Draper::Decorator
  delegate_all

  def chart_name
    "#{Currency.find(target_currency_id).name}"
  end

  def base_amount
    "#{amount} #{base_curr_name}"
  end
end
