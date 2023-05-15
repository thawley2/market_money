require 'rails_helper'

RSpec.describe Market, type: :model do
  before(:each) do
    test_data
  end

  describe 'relationships' do
    it {should have_many(:market_vendors)}
    it {should have_many(:vendors).through(:market_vendors)}
  end

  describe 'instance methods' do
    describe '#count_of_vendors' do
      it 'returns the number of vendors linked to a market' do
        expect(@market1.count_of_vendors).to eq(4)
        expect(@market2.count_of_vendors).to eq(1)
        expect(@market3.count_of_vendors).to eq(0)
      end
    end
  end
end