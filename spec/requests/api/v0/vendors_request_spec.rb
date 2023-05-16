require 'rails_helper'

RSpec.describe 'Vendors API' do
  before(:each) do
    test_data
  end

  describe 'Sends Vendors' do
    it 'Sends all vendors for a market' do
      get "/api/v0/markets/#{@market1.id}/vendors"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to be_an Array
      expect(json[:data].count).to eq(4)

      json[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor).to have_key(:type)
        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes]).to have_key(:credit_accepted)

        expect(vendor[:attributes][:name]).to be_a String
        expect(vendor[:attributes][:description]).to be_a String
        expect(vendor[:attributes][:contact_name]).to be_a String
        expect(vendor[:attributes][:contact_phone]).to be_a String
        expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      end
    end

    it 'Can send an error message if no market was found' do
      get "/api/v0/markets/1000000/vendors"

      expect(response).to_not be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1000000")
    end
  end

  describe 'Send Vendor' do
    it 'Can send a single vendor' do
      get "/api/v0/vendors/#{@vendor1.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to be_a Hash
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes]).to have_key(:description)
      expect(json[:data][:attributes]).to have_key(:contact_name)
      expect(json[:data][:attributes]).to have_key(:contact_phone)
      expect(json[:data][:attributes]).to have_key(:credit_accepted)

      json_attr = json[:data][:attributes]

      expect(json_attr[:name]).to eq(@vendor1.name)
      expect(json_attr[:description]).to eq(@vendor1.description)
      expect(json_attr[:contact_name]).to eq(@vendor1.contact_name)
      expect(json_attr[:contact_phone]).to eq(@vendor1.contact_phone)
      expect(json_attr[:credit_accepted]).to eq(@vendor1.credit_accepted)
    end

    it 'Can send an error message if no vendor was found' do
      get '/api/v0/vendors/1000000'

      expect(response).to_not be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1000000")
    end
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
      expect(response.status).to eq 201

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a Hash

      json_attr = json[:data][:attributes]

      expect(json_attr[:name]).to eq(Vendor.last.name)
      expect(json_attr[:description]).to eq(Vendor.last.description)
      expect(json_attr[:contact_name]).to eq(Vendor.last.contact_name)
      expect(json_attr[:contact_phone]).to eq(Vendor.last.contact_phone)
      expect(json_attr[:credit_accepted]).to eq(Vendor.last.credit_accepted)
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

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")

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

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Validation failed: Name can't be blank, Description can't be blank")

      expect(Vendor.last.name).to_not eq(vendor_params[:"name"])
      expect(Vendor.last.description).to_not eq(vendor_params[:"description"])
    end
  end
end