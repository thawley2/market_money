require 'rails_helper'

RSpec.describe 'MarketVendor API' do
  before(:each) do
    test_data
  end

  describe 'Market destroy' do
    it 'Sends a status of 204 when successfully deleted' do
      expect(@market2.vendors.count).to eq(1)
      expect(@market2.vendors).to eq([@vendor1])

      mv_params = {
        "market_id": "#{@market2.id}",
        "vendor_id": "#{@vendor1.id}"
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(@market2.vendors.count).to eq(0)
      expect(@vendor1.markets).to eq([@market1])

        get "/api/v0/markets/#{@market2.id}/vendors"

        vendors = JSON.parse(response.body, symbolize_names: true)

        expect(vendors[:data]).to eq([])
    end

    it 'Sends an error message when the marketvendor record can not be found' do
      mv_params = {
        "market_id": "#{@market4.id}",
        "vendor_id": "#{@vendor1.id}"
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("No MarketVendor with market_id=#{@market4.id} AND vendor_id=#{@vendor1.id} exists")
    end

    it 'Sends the same error if the market id doesnt exist' do
      mv_params = {
        "market_id": "1000000",
        "vendor_id": "#{@vendor1.id}"
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("No MarketVendor with market_id=1000000 AND vendor_id=#{@vendor1.id} exists")
    end

    it 'Sends the same error if the market id is missing' do
      mv_params = {
        "market_id": "",
        "vendor_id": "#{@vendor1.id}"
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("No MarketVendor with market_id= AND vendor_id=#{@vendor1.id} exists")
    end
  end
end