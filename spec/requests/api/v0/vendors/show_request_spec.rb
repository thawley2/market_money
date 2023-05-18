require 'rails_helper'

RSpec.describe 'Vendors API' do
  before(:each) do
    test_data
  end
  describe 'Send Vendor' do
    it 'Can send a single vendor' do
      get "/api/v0/vendors/#{@vendor1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      vendor_deets = JSON.parse(response.body, symbolize_names: true)

      expect(vendor_deets).to be_a Hash
      expect(vendor_deets).to have_key(:data)
      expect(vendor_deets[:data]).to be_a Hash
      expect(vendor_deets[:data]).to have_key(:id)
      expect(vendor_deets[:data]).to have_key(:type)
      expect(vendor_deets[:data]).to have_key(:attributes)
      expect(vendor_deets[:data][:attributes]).to have_key(:name)
      expect(vendor_deets[:data][:attributes]).to have_key(:description)
      expect(vendor_deets[:data][:attributes]).to have_key(:contact_name)
      expect(vendor_deets[:data][:attributes]).to have_key(:contact_phone)
      expect(vendor_deets[:data][:attributes]).to have_key(:credit_accepted)

      vendor_deets_attr = vendor_deets[:data][:attributes]

      expect(vendor_deets_attr[:name]).to eq(@vendor1.name)
      expect(vendor_deets_attr[:description]).to eq(@vendor1.description)
      expect(vendor_deets_attr[:contact_name]).to eq(@vendor1.contact_name)
      expect(vendor_deets_attr[:contact_phone]).to eq(@vendor1.contact_phone)
      expect(vendor_deets_attr[:credit_accepted]).to eq(@vendor1.credit_accepted)
    end

    it 'Can send an error message if no vendor was found' do
      get '/api/v0/vendors/1000000'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1000000")
    end
  end
end