class BeerSearch
  def initialize(search_params)
    @search_params = search_params
  end

  def search_result
    @search_result ||= google_results.first
  end

  private

  attr_reader :search_params

  def search_query
    search_params[:address]
  end

  def google_results
    @google_result ||= google_places.spots(lat, lon, opennow: 'openow', rankby: 'distance', types: search_type, verify: false)
  end

  def geocode_results
    @geocode_results ||= Geocoder.search(search_query)
  end

  def google_places
    @google_places ||= GooglePlaces::Client.new(ENV['PLACES_API_KEY'])
  end

  def lat
    geocode_results.first.geometry['location']['lat']
  end

  def lon
    geocode_results.first.geometry['location']['lng']
  end

  def search_type
    [search_params[:search_type]]
  end
end
