require 'rails_helper'

RSpec.describe 'ATM Search API' do
  describe 'Locate ATM' do
    xit 'Can find a list of atms based on market location ordered by closeness' do
      market_data
      get "/api/v0/markets/#{@market6.id}/nearest_atms"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      atms = JSON.parse(response.body, symbolize_names: true)

      expect(atms).to have_key(:data)
      expect(atms[:data]).to be_an Array

      atms[:data].each do |atm|
        expect(atm).to have_key(:id)
        expect(atm).to have_key(:type)
        expect(atm).to have_key(:attributes)
        atm_atr = atm[:attributes]

        expect(atm_atr).to have_key(:name)
        expect(atm_atr).to have_key(:address)
        expect(atm_atr).to have_key(:lat)
        expect(atm_atr).to have_key(:lon)
        expect(atm_atr).to have_key(:distance)

        expect(atm_atr[:name]).to be_a String
        expect(atm_atr[:address]).to be_a String
        expect(atm_atr[:lat]).to be_a Float
        expect(atm_atr[:lon]).to be_a Float
        expect(atm_atr[:distanct]).to be_a Float
      end
    end
  end
end