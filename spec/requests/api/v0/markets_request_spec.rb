require 'rails_helper'

RSpec.describe 'Markets API' do
  before(:each) do
    test_data
  end

  describe 'Sends markets' do
    it 'Sends a list of all markets' do
      get '/api/v0/markets'

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:data]).to be_an Array
      expect(json[:data].count).to eq(4)

      json[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market).to have_key(:attributes)
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

  describe 'Sends a single market' do
    it 'If a valid request it sends the market data' do
      get "/api/v0/markets/#{@market1.id}"
      
      expect(response).to be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:data]).to be_a Hash
      
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a Hash
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes]).to have_key(:street)
      expect(json[:data][:attributes]).to have_key(:city)
      expect(json[:data][:attributes]).to have_key(:county)
      expect(json[:data][:attributes]).to have_key(:state)
      expect(json[:data][:attributes]).to have_key(:zip)
      expect(json[:data][:attributes]).to have_key(:lat)
      expect(json[:data][:attributes]).to have_key(:lon)
      expect(json[:data][:attributes]).to have_key(:vendor_count)
      
      expect(json[:data][:attributes][:name]).to eq(@market1.name)
      expect(json[:data][:attributes][:street]).to eq(@market1.street)
      expect(json[:data][:attributes][:city]).to eq(@market1.city)
      expect(json[:data][:attributes][:county]).to eq(@market1.county)
      expect(json[:data][:attributes][:state]).to eq(@market1.state)
      expect(json[:data][:attributes][:zip]).to eq(@market1.zip)
      expect(json[:data][:attributes][:lat]).to eq(@market1.lat)
      expect(json[:data][:attributes][:lon]).to eq(@market1.lon)
      expect(json[:data][:attributes][:vendor_count]).to eq(@market1.vendor_count)
    end

    it 'If an invalid request, returns an error message and 404' do
      get "/api/v0/markets/#{1000000}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1000000")

    end
  end
end