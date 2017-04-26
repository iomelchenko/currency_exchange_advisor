require 'rails_helper.rb'

describe User do
  describe 'model associations' do
    it { should have_many(:forecasts) }
  end

  describe 'model validations' do
    it { should validate_uniqueness_of(:username) }
  end
end
