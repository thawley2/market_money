require 'rails_helper'

RSpec.describe Atm do
  it 'exists and has attributes' do
    atm_data = {
      name: 'Money', 
      address: '123 South, Denver, CO 80123',
      lat: 3.245,
      lon: 4.526,
      distance: 1.02
    }

    atm = Atm.new(atm_data)

    expect(atm.name).to eq('Money')
    expect(atm.address).to eq('123 South, Denver, CO 80123')
    expect(atm.lat).to eq(3.245)
    expect(atm.lon).to eq(4.526)
    expect(atm.distance).to eq(1.02)
  end
end