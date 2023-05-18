require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it {should have_many(:market_vendors)}
    it {should have_many(:vendors).through(:market_vendors)}
  end

  describe 'instance methods' do
    describe '#vendor_count' do
      it 'returns the number of vendors linked to a market' do
        test_data
        expect(@market1.vendor_count).to eq(4)
        expect(@market2.vendor_count).to eq(1)
        expect(@market3.vendor_count).to eq(0)
      end
    end

    describe 'class methods' do
      describe '::search_state' do
        it 'can return a list of vendors from a state query, case insensitive' do
          market_data
          params = {state: 'Oklahoma'}
          params2 = {state: 'oklahoma'}
          params3 = {state: 'OK'}
          expect(Market.search_state(params)).to eq([@market1, @market2])
          expect(Market.search_state(params2)).to eq([@market1, @market2])
          expect(Market.search_state(params3)).to eq([@market1, @market2])
        end
      end

      describe '::search_name' do
        it 'can return a list of vendors from a name query, case insensitive' do
          market_data
          params = {name: 'Walmart'}
          params2 = {name: 'walmart'}
          params3 = {name: 'mart'}
          expect(Market.search_name(params)).to eq([@market1])
          expect(Market.search_name(params2)).to eq([@market1])
          expect(Market.search_name(params3)).to eq([@market1])
        end
      end
    end
  end
end