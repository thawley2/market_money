require 'rails_helper'

RSpec.describe 'Vendors API' do
  before(:each) do
    test_data
  end
  describe 'Create Vendor' do
    it 'Can create a vendor' do
      vendor_params = {
        "name": "Buzzy Bees",
        "description": "local honey and wax products",
        "contact_name": "Berly Couwer",
        "contact_phone": "8389928383",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
        
      expect(response).to be_successful
      expect(response.status).to eq(201)

      vendor_deets = JSON.parse(response.body, symbolize_names: true)

      expect(vendor_deets).to be_a Hash
      expect(vendor_deets).to have_key(:data)
      expect(vendor_deets[:data]).to have_key(:id)
      expect(vendor_deets[:data]).to have_key(:type)
      expect(vendor_deets[:data]).to have_key(:attributes)
      expect(vendor_deets[:data][:attributes]).to be_a Hash

      vendor_deets_attr = vendor_deets[:data][:attributes]

      expect(vendor_deets_attr[:name]).to eq(Vendor.last.name)
      expect(vendor_deets_attr[:description]).to eq(Vendor.last.description)
      expect(vendor_deets_attr[:contact_name]).to eq(Vendor.last.contact_name)
      expect(vendor_deets_attr[:contact_phone]).to eq(Vendor.last.contact_phone)
      expect(vendor_deets_attr[:credit_accepted]).to eq(Vendor.last.credit_accepted)
    end

    it 'Sends an error message if all fields are not included' do
      vendor_params = {
        "name": "Buzzy Bees",
        "description": "local honey and wax products",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")

      expect(Vendor.last.name).to_not eq(vendor_params[:"name"])
      expect(Vendor.last.description).to_not eq(vendor_params[:"description"])
    end

    it 'Sends an error message if missing other fields' do
      vendor_params = {
        "contact_name": "Steve",
        "contact_phone": "7775859898",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Name can't be blank, Description can't be blank")

      expect(Vendor.last.name).to_not eq(vendor_params[:"name"])
      expect(Vendor.last.description).to_not eq(vendor_params[:"description"])
    end
  end
end