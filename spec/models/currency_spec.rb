require 'rails_helper.rb'

describe Currency do
  describe 'model associations' do
    it { should have_many(:historical_currency_rates) }
  end

  describe 'model validations' do
    it { should validate_presence_of(:id) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:id) }
    it { should validate_uniqueness_of(:name) }
  end
end
