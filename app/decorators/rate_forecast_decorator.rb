class RateForecastDecorator < ApplicationDecorator
  delegate_all

  def year_with_week
    "#{object.year}, week ##{object.week_number}"
  end
end
