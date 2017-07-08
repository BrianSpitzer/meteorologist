require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    parsed_address_data = JSON.parse(open("https://maps.googleapis.com/maps/api/geocode/json?address="+@street_address).read)
    latitude = parsed_address_data["results"][0]["geometry"]["location"]["lat"]
    longitude = parsed_address_data["results"][0]["geometry"]["location"]["lng"]
    
    parsed_weather_data = JSON.parse(open("https://api.darksky.net/forecast/71ad3bc228ca1dd749a2c1bfeadba728/"+latitude.to_s+","+longitude.to_s).read)

    @current_temperature = parsed_weather_data.dig("currently", "temperature")

    @current_summary = parsed_weather_data.dig("currently","summary")
    
    @summary_of_next_sixty_minutes = parsed_weather_data.dig("minutely","summary")
    
    @summary_of_next_several_hours = parsed_weather_data.dig("hourly","summary")

    @summary_of_next_several_days = parsed_weather_data.dig("daily","summary")

    render("meteorologist/street_to_weather.html.erb")
  end
end
