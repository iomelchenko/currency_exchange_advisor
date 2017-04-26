require 'rails_helper.rb'

describe RateForecast do
  describe 'model associations' do
    it { should belong_to(:forecast) }
  end
end
