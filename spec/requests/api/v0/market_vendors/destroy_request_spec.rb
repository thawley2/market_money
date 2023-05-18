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
  end
end