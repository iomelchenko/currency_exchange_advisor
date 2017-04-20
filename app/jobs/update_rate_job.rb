class UpdateRateJob < ApplicationJob
  queue_as :default
  RUN_EVERY = 4.hours

  def perform
    FixerClient.new.load_currency_rates_if_needed
    self.class.set(wait: RUN_EVERY).perform_later
  end
end
