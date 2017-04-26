require 'rails_helper.rb'

describe HistoricalCurrencyRate do
  describe 'model associations' do
    it { should belong_to(:currency) }
  end
end
