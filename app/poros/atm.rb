class Atm
  attr_reader :name, :address, :lat, :lon, :distance
  def initialize(atm_data)
    @name = atm_data[:name]
    @address = atm_data[:address]
    @lat = atm_data[:lat]
    @lon = atm_data[:lon]
    @distance = atm_data[:distance]
  end
end