namespace :rates do
  desc 'Load all rates'
  task load_all_currency_rates: :environment do
    FixerClient.new(:historical).load_currency_rates
  end
end
