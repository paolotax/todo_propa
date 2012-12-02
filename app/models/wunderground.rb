require 'open-uri'
require 'json'
require 'ostruct'

class Wunderground

  attr_reader :conditions,
              :day_0_night, :day_0_morning, 
              :day_1_morning, :day_1_night,
              :day_2_morning, :day_2_night,
              :day_3_morning, :day_3_night

  def initialize(location="bologna")
    @location = location
    condizioni
  end

  def condizioni
    begin
      url  = "http://api.wunderground.com/api/#{CONFIG[:wunderground_key]}/conditions/forecast/lang:IT/q/IT/#{@location}.json"
      data = open(url).read
      @conditions = OpenStruct.new(JSON.parse(data)['current_observation'])
      @observation = OpenStruct.new(JSON.parse(data))
      popola_previsioni
    rescue SocketError => ex
      @conditions = OpenStruct.new({ 
          display_location: "Non sono stati trovati dati per #{@location}",
          })
      @observation = OpenStruct.new({ 
          display_location: "Non sono stati trovati dati per #{@location}",
          })
    rescue NoMethodError => ex
      @conditions = OpenStruct.new({ 
          display_location: "Non sono stati trovati dati per #{@location}",
          })
      @observation = OpenStruct.new({ 
          display_location: "Non sono stati trovati dati per #{@location}",
          })
    end 
  end

  def forecast
    @observation.forecast['txt_forecast']['forecastday'] ||=  []
  end

  def popola_previsioni
    @day_0_morning = OpenStruct.new(forecast[0]) 
    @day_0_night   = OpenStruct.new(forecast[1]) 
    @day_1_morning = OpenStruct.new(forecast[2]) 
    @day_1_night   = OpenStruct.new(forecast[3]) 
    @day_2_morning = OpenStruct.new(forecast[4]) 
    @day_2_nigth   = OpenStruct.new(forecast[5]) 
    @day_3_morning = OpenStruct.new(forecast[6]) 
    @day_3_night   = OpenStruct.new(forecast[7]) 
  end

  def non_trovato?
    conditions.display_location == "Non sono stati trovati dati per #{@location}";
  end
end


# w = Wunderground.new('modena').previsioni
# puts w.to_s