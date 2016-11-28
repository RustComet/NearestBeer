class HomeController < ApplicationController
  before_action :validate_search!, only: [:search]
  def index
  end

  def search
    @search_result ||= beer_search.search_result
    unless @search_result
      flash[:error] = "Sorry, looks like there's no beer nearby"
      return redirect_to root_path
    end
    @map_link = google_maps_link
  end

  private

  def search_params
    params.require(:location).permit(:address, :search_type)
  end

  def beer_search
    @beer_search ||= BeerSearch.new(search_params)
  end

  def google_maps_link
    @google_maps_link ||= "https://www.google.com.au/maps/place/#{@search_result&.name}+#{@search_result&.vicinity}"
  end

  def validate_search!
    unless search_params[:address].present?
      flash[:error] = 'You need to specify an address to search'
      return redirect_to root_path
    end
  end
end

