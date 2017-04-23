class RateForecastDecorator < ApplicationDecorator
  delegate_all

  def year_with_week
    "#{object.year}, week ##{object.week_number}"
  end

  def max_ranks
    object.rank if object.rank < 4
  end

  def target_amount(amount)
    (amount * object.avg_rate).round(2)
  end

  def profit_loss(first_rate, amount)
    profit_loss = ((object.avg_rate - first_rate) * amount).round(2)
    profit_loss if profit_loss != 0
  end
end
