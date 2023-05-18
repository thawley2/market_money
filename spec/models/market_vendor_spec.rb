require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  describe 'relationships' do
    it {should belong_to(:market)}
    it {should belong_to(:vendor)}
  end

  describe 'validations' do
    it {should validate_presence_of(:market_id)}
    it {should validate_presence_of(:vendor_id)}
    # it {should validate_uniqueness_of(:market_id).scoped_to(:vendor_id)}
  end

end