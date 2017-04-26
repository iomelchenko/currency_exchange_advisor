require 'rails_helper.rb'

describe Forecast do
  describe 'model associations' do
    it { should belong_to(:user) }
    it { should have_many(:rate_forecasts) }
  end

  describe 'model validations' do
    it { should validate_presence_of(:base_currency_id) }
    it { should validate_presence_of(:target_currency_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:term_in_weeks) }
    it { should validate_numericality_of(:amount) }
  end
end
