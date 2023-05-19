class Atm
  attr_reader :name, :address, :lat, :lon, :distance, :id
  def initialize(atm_data)
    @id = nil
    @name = atm_data[:name]
    @address = atm_data[:address]
    @lat = atm_data[:lat]
    @lon = atm_data[:lon]
    @distance = atm_data[:distance]
  end
end