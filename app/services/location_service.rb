class LocationService
  def nearby_atms(lat, lon)
    get_url("/search/2/categorySearch/cash_dispenser.json?lat=#{lat}&lon=#{lon}")
  end
  
  private
    def conn
      Faraday.new(url: 'https://api.tomtom.com') do |f|
        f.params['key'] = ENV['TomTom_API_KEY']
      end
    end
    
    def get_url(url)
      response = conn.get(url)
      JSON.parse(response.body, symbolize_names: true)
    end
end