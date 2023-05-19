require 'rails_helper' 

RSpec.describe LocationService do
  describe 'Establish connection' do
    it 'Can return a list of nearby atms from a lat/lon' do
      VCR.use_cassette('atms_near_me') do
        atms = LocationService.new.nearby_atms(35.077529, -106.600449)
        
        expect(atms).to have_key(:results)
        expect(atms[:results]).to be_an Array

        atms_results = atms[:results]

        atms_results.each do |atm|
          expect(atm).to have_key(:dist)
          expect(atm[:dist]).to be_a Float
          expect(atm).to have_key(:poi)
          expect(atm[:poi]).to have_key(:name)
          expect(atm).to have_key(:address)
          expect(atm[:address]).to have_key(:freeformAddress)
          expect(atm).to have_key(:position)
          expect(atm[:position]).to have_key(:lat)
          expect(atm[:position]).to have_key(:lon)
        end
      end
    end
  end
end