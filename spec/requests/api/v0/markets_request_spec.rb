require 'rails_helper'

RSpec.describe 'Markets API' do
  before(:each) do
    create_list(:market, 5)
  end

  describe 'Sends markets' do
    it 'Sends a list of all markets' do
      get '/api/v0/markets'

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:data]).to be_an Array
      expect(json[:data].count).to eq(5)
      json[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market[:attributes]).to be_a Hash
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes]).to have_key(:vendor_count)

        expect(market[:attributes][:name]).to be_a String
        expect(market[:attributes][:street]).to be_a String
        expect(market[:attributes][:city]).to be_a String
        expect(market[:attributes][:county]).to be_a String
        expect(market[:attributes][:state]).to be_a String
        expect(market[:attributes][:zip]).to be_a String
        expect(market[:attributes][:lat]).to be_a String
        expect(market[:attributes][:lon]).to be_a String
        expect(market[:attributes][:vendor_count]).to be_an Integer
      end
    end
  end
end