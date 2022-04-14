class CitiesController < ApplicationController
  before_action :set_city, except: :search
  before_action :get_attractions, except: :search

  def search
    if params.dig(:city_search).present?
      @cities = City.where('lower(name) LIKE ?', "#{params[:city_search].downcase}%").limit(10)
    else 
      @cities = []
    end
    render turbo_stream: turbo_stream.update("search_results", partial: "cities/search_results", locals: { cities: @cities })
  end

  def attractions
    render turbo_stream: turbo_stream.update('attractions', partial: 'cities/attractions', locals: { attractions: @attractions })
  end
  
  private
  def set_city
    @city = City.find(params[:id])
  end

  def get_attractions
    query = {location: "#{@city.name}, #{@city.state}", limit: 10, categories: params[:category] || 'restaurants'}
    headers = {Authorization: "Bearer #{ENV['YELP_API_KEY']}"}
    @attractions = HTTParty.get("https://api.yelp.com/v3/businesses/search", query: query, headers: headers)['businesses']      
  end

end
