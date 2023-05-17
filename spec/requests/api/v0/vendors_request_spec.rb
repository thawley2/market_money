require 'rails_helper'

RSpec.describe 'Vendors API' do
  before(:each) do
    test_data
  end

  describe 'Sends Vendors' do
    it 'Sends all vendors for a market' do
      get "/api/v0/markets/#{@market1.id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors).to be_a Hash
      expect(vendors).to have_key(:data)
      expect(vendors[:data]).to be_an Array
      expect(vendors[:data].count).to eq(4)

      vendors[:data].each do |vendor|
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
      expect(response.status).to eq(404)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1000000")
    end
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

  describe 'Update Vendor' do
    it 'can update a vendor' do
      p_contact_name = @vendor1.contact_name
      p_credit_accepted = @vendor1.credit_accepted

      vendor_params = {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v0/vendors/#{@vendor1.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      vendor_deets = JSON.parse(response.body, symbolize_names: true)

      expect(vendor_deets).to be_a Hash
      expect(vendor_deets).to have_key(:data)
      expect(vendor_deets[:data]).to have_key(:id)
      expect(vendor_deets[:data]).to have_key(:type)
      expect(vendor_deets[:data]).to have_key(:attributes)
      expect(vendor_deets[:data][:attributes]).to be_a Hash

      vendor_deets_attr = vendor_deets[:data][:attributes]

      expect(vendor_deets_attr[:name]).to eq(@vendor1.name)
      expect(vendor_deets_attr[:description]).to eq(@vendor1.description)
      expect(vendor_deets_attr[:contact_name]).to eq(vendor_params[:"contact_name"])
      expect(vendor_deets_attr[:contact_phone]).to eq(@vendor1.contact_phone)
      expect(vendor_deets_attr[:credit_accepted]).to eq(vendor_params[:"credit_accepted"])

    end

    it 'Can send an error message if no vendor was found to update 404' do
      vendor_params = {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v0/vendors/1000000", headers: headers, params: JSON.generate(vendor: vendor_params)

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

    it 'Can send an error message if non valid data is passed to update 400' do
      vendor_params = {
        "contact_name": "",
        "credit_accepted": false
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v0/vendors/#{@vendor1.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_deets = JSON.parse(response.body, symbolize_names: true)

      expect(error_deets).to be_a Hash
      expect(error_deets).to have_key(:errors)
      expect(error_deets[:errors]).to be_an Array
      expect(error_deets[:errors][0]).to be_a Hash
      expect(error_deets[:errors][0]).to have_key(:detail)
      expect(error_deets[:errors][0][:detail]).to be_a String
      expect(error_deets[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank")
    end
  end

  describe 'Delete Vendor' do
    it 'Can delete a vendor through its id' do

      expect(Vendor.count).to eq(5)
      
      delete "/api/v0/vendors/#{@vendor1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Vendor.count).to eq(4)
    end

    it 'Can send an error if the vendor id does not exist 404' do
      delete "/api/v0/vendors/1000000"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      vendor_deets = JSON.parse(response.body, symbolize_names: true)

      expect(vendor_deets).to be_a Hash
      expect(vendor_deets).to have_key(:errors)
      expect(vendor_deets[:errors]).to be_an Array
      expect(vendor_deets[:errors][0]).to be_a Hash
      expect(vendor_deets[:errors][0]).to have_key(:detail)
      expect(vendor_deets[:errors][0][:detail]).to be_a String
      expect(vendor_deets[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=1000000")
    end
  end
end