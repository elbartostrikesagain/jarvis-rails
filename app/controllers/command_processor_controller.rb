class CommandProcessorController < ApplicationController

  def index
    # lots of real logic needed here. Stuff is going to need to be extracted from here eventually...
    params[:q] = params[:q].strip
    processor = CommandProcessor.new(params[:q])

    unless processor.is_command?
        render json: {} and return
    end

    extracted_command = processor.extract_command
    extracted_command_name = extracted_command["command"]

    if extracted_command_name == "weather"
        weather_data = open("http://api.openweathermap.org/data/2.5/find?q=Boulder,co&units=imperial").read() #todo
        weather_data_temp_avg = JSON.parse(weather_data)['list'][0]['main']['temp']
        weather_data_weather_desc = JSON.parse(weather_data)['list'][0]['weather'][0]['description']
        response_data = {'command'=>'speak','data'=>"It is #{weather_data_temp_avg} degrees outside with #{weather_data_weather_desc}"}
    elsif extracted_command_name == "temperature"
        weather_data = open("http://api.openweathermap.org/data/2.5/find?q=Boulder,co&units=imperial").read()
        weather_data_temp_avg = JSON.parse(weather_data)['list'][0]['main']['temp']
        weather_data_temp_high = JSON.parse(weather_data)['list'][0]['main']['temp_max']
        weather_data_temp_low = JSON.parse(weather_data)['list'][0]['main']['temp_min']
        response_data = {'command' => 'speak','data' => "It is #{weather_data_temp_avg} degrees outside with a high of #{weather_data_temp_high} degrees and a low of #{weather_data_temp_low} degrees"}
    elsif extracted_command_name == "wind"
        weather_data = open("http://api.openweathermap.org/data/2.5/find?q=Boulder,co&units=imperial").read()
        weather_data_wind_speed = JSON.parse(weather_data)['list'][0]['wind']['speed']
        weather_data_wind_heading = JSON.parse(weather_data)['list'][0]['wind']['deg']
        response_data = {'command' => 'speak','data' => "The wind speed is currently #{weather_data_wind_speed} miles per hour with heading #{weather_data_wind_heading}"}
    elsif extracted_command_name == "play"
        youtube_data = open('https://www.googleapis.com/youtube/v3/search?q='+extracted_command['data']+'&key=AIzaSyBL6aPKYByygs9oHB5rStYhTBKtklqRkrI&part=snippet').read()
        youtube_data_url = JSON.parse(youtube_data)['items'][0]['id']['videoId'];
        response_data = {'command' => 'playerAction','data' => ['play', youtube_data_url]}
    elsif extracted_command_name == "pause"
        response_data = {'command' => 'playerAction','data' => "pause"}
    elsif extracted_command_name == "resume"
        response_data = {'command' => 'playerAction','data' => "resume"}
    elsif extracted_command_name == "volume"
        volume = int(re.search('\d+',extracted_command['data']).group(0))
        response_data = {'command' => 'playerAction','data' => ['volume',volume]}
    elsif extracted_command_name == "ask"
        response_data = {'command' => 'speak','data' => extracted_command["data"]}
    elsif extracted_command_name == "time"
        response_data = {'command' => 'speak','data' => 'time'}
    else
        response_data = {'command' => 'speak','data' => 'That command is not yet avaliable or was stated in a way I do not understand'}
    end

    render json: response_data.as_json
  end

end