class AtmFacade
  attr_reader :market
  def initialize(market)
    @market = market
  end

  def atms
    @_atms ||= atms_data.map do |atm_data|
      Atm.new(format_atm_data(atm_data))
    end
  end

  private
  def service
    @_service ||= LocationService.new
  end

  def atms_data
    @_atm_data ||= service.nearby_atms(@market.lat, @market.lon)[:results]
  end

  def format_atm_data(data)
    format = {
      name: data[:poi][:name],
      address: format_address(data[:address]),
      lat: data[:position][:lat],
      lon: data[:position][:lat],
      distance: format_distance(data[:dist])
    }
  end

  def format_distance(meter)
    miles = meter/1609
  end

  def format_address(addr)
    address = "#{addr[:streetNumber]} #{addr[:streetName]}, #{addr[:municipality]}, #{addr[:countrySubdivision]} #{addr[:postalCode]}"
  end
end
