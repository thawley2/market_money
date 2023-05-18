require 'rails_helper'

RSpec.describe 'Markets Search API' do
  before(:each) do
    market_data
  end
  describe 'Happy Path Markets Search' do
    it 'Can search markets by state' do
      headers = {"CONTENT_TYPE" => "application/json"}
      get "/api/v0/markets/search?state=oklahoma", headers: headers
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      market_search = JSON.parse(response.body, symbolize_names: true)
      
      expect(market_search).to be_a Hash
      expect(market_search[:data]).to be_an Array
      expect(market_search[:data].count).to eq(2)

      market_search[:data].each do |market|
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
      end
      first_market = market_search[:data].first[:attributes]
    
      expect(first_market[:name]).to eq(@market1.name)
      expect(first_market[:street]).to eq(@market1.street)
      expect(first_market[:city]).to eq(@market1.city)
      expect(first_market[:county]).to eq(@market1.county)
      expect(first_market[:state]).to eq('Oklahoma')
      expect(first_market[:zip]).to eq(@market1.zip)
      expect(first_market[:lat]).to eq(@market1.lat)
      expect(first_market[:lon]).to eq(@market1.lon)
      expect(first_market[:vendor_count]).to eq(0)

      second_market = market_search[:data].last[:attributes]

      expect(second_market[:name]).to eq(@market2.name)
      expect(second_market[:street]).to eq(@market2.street)
      expect(second_market[:city]).to eq(@market2.city)
      expect(second_market[:county]).to eq(@market2.county)
      expect(second_market[:state]).to eq('Oklahoma')
      expect(second_market[:zip]).to eq(@market2.zip)
      expect(second_market[:lat]).to eq(@market2.lat)
      expect(second_market[:lon]).to eq(@market2.lon)
      expect(second_market[:vendor_count]).to eq(0)
    end

    it 'Can search Market by name' do
      headers = {"CONTENT_TYPE" => "application/json"}
      get "/api/v0/markets/search?name=walmart", headers: headers
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      market_search = JSON.parse(response.body, symbolize_names: true)
      
      expect(market_search).to be_a Hash
      expect(market_search[:data]).to be_an Array
      expect(market_search[:data].count).to eq(1)

      market_search[:data].each do |market|
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
      end
      first_market = market_search[:data].first[:attributes]
    
      expect(first_market[:name]).to eq(@market1.name)
      expect(first_market[:street]).to eq(@market1.street)
      expect(first_market[:city]).to eq(@market1.city)
      expect(first_market[:county]).to eq(@market1.county)
      expect(first_market[:state]).to eq('Oklahoma')
      expect(first_market[:zip]).to eq(@market1.zip)
      expect(first_market[:lat]).to eq(@market1.lat)
      expect(first_market[:lon]).to eq(@market1.lon)
      expect(first_market[:vendor_count]).to eq(0)
    end
  end
end