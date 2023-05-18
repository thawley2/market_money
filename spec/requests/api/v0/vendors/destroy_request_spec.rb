require 'rails_helper'

RSpec.describe 'Vendors API' do
  before(:each) do
    test_data
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