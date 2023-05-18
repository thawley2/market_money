require 'rails_helper'

RSpec.describe 'MarketVendor API' do
  before(:each) do
    test_data
  end

  describe 'Create MarketVendor' do
    it 'Can create a new MarketVendor association 201' do
      
      expect(@market2.vendors).to eq([@vendor1])

      mv_params = {
        "market_id": "#{@market2.id}",
        "vendor_id": "#{@vendor5.id}"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)
      
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      message = JSON.parse(response.body, symbolize_names: true)
      
      expect(message).to be_a Hash
      expect(message).to have_key(:message)
      expect(message[:message]).to eq("Successfully added vendor to market")
      expect(@market2.reload.vendors).to eq([@vendor1, @vendor5])
    end

    it 'Can see the newly created relationship by checking' do
      get "/api/v0/markets/#{@market2.id}/vendors"

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors[:data].count).to eq(1)
      expect(vendors[:data].first[:id]).to_not eq(@vendor5.id)

      mv_params = {
        "market_id": "#{@market2.id}",
        "vendor_id": "#{@vendor5.id}"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      get "/api/v0/markets/#{@market2.id}/vendors"

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors[:data].count).to eq(2)
      expect(vendors[:data].first[:id]).to_not eq("#{@vendor5.id}")
      expect(vendors[:data].last[:id]).to eq("#{@vendor5.id}")
    end

    it 'Can send an error message when market id does not exist 404' do
      mv_params = {
        "market_id": "1000000",
        "vendor_id": "#{@vendor5.id}"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Market must exist")
    end

    it 'Can send an error message when the relationship already exists 422' do
      mv_params = {
        "market_id": "#{@market1.id}",
        "vendor_id": "#{@vendor1.id}"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{@market1.id} and vendor_id=#{@vendor1.id} already exists")
    end

    it 'Can send an error message when either a market_id or vendor_id is not passed 400' do
      mv_params = {
        "market_id": "",
        "vendor_id": "#{@vendor1.id}"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mv: mv_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Market must exist, Market can't be blank")
    end
  end
end
