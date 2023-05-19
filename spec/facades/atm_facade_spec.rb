require 'rails_helper'

RSpec.describe AtmFacade do
  describe 'Initialize' do
    it 'exists' do
      atms = AtmFacade.new(@market6)

      expect(atms).to be_a(AtmFacade)
    end
  end

  describe 'Create Objects' do
    it 'can create an array of atm objects' do
      VCR.use_cassette('atms_near_me') do
        market_data
        facade = AtmFacade.new(@market6)
        
        expect(facade.atms).to be_an Array
        expect(facade.atms.first).to be_a Atm
        facade.atms.each do |atm|
          expect(atm.name).to be_a String
          expect(atm.address).to be_a String
          expect(atm.distance).to be_a Float
          expect(atm.lat).to be_a Float
          expect(atm.lon).to be_a Float
        end
      end
    end
  end
end