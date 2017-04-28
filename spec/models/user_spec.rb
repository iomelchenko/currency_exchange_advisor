require 'rails_helper.rb'

describe User do
  describe 'model associations' do
    it { should have_many(:forecasts) }
  end

  describe 'model validations' do
    let!(:test_user) do
      create :user, email: 'test@test.com', username: 'test_user'
    end

    let(:user_params) do
      { password: '123456', password_confirmation: '123456' }
    end

    it { should validate_uniqueness_of(:username) }

    it 'should return already exists error' do
      user_params.merge!(username: 'test@test.com', email: 'test_2@test.com')
      user = User.create(user_params)
      expect(user.errors[:username].first)
        .to eql 'Username (as email) already exists'
    end
  end
end
