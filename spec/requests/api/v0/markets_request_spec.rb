require 'rails_helper'

RSpec.describe 'Markets API' do
  before(:each) do
    create_list(:market, 5)
  end

  describe 'Sends markets' do
    it 'Sends a list of all markets' do
      get '/api/v0/markets'

      json = JSON.parse(response.body, symbolize_names: true)
      require 'pry'; binding.pry
      expect(json).to be_an Array
      expect(json.count).to eq(5)
    end
  end
end