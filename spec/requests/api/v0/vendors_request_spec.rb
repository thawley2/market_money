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

      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors][0]).to be_a Hash
      expect(json[:errors][0]).to have_key(:detail)
      expect(json[:errors][0][:detail]).to be_a String
      expect(json[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1000000")
    end
  end
end