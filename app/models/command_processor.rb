class CommandProcessor
  attr_accessor :command
  
  def initialize(command)
    @command = command
  end

  def extract_command
    return {} unless self.is_command?

    entities = command.split(' ')
    entities = entities[1..entities.length] #probably a better way to remove first element

    entities.each do |entity|
      if entity == "weather"
        return {"command" => "weather"}
      elsif entity == "temp" || entity == "temperature"
        return {"command" => "temperature"}
      elsif entity == "wind"
        return {"command" => "wind"}
      elsif entity == "time"
        return {'command' => 'time'}
      elsif entity == "volume"
        return {'command' => 'volume','data' => ' '.join(entities)}
      end
    end

    #check for music
    if entities[0] == "play" && entities.length > 1
      entites = entities[1..entities.length]
      return {'command' => 'play', 'data' => URI.encode(entities.join(" "))}
    
    #check for pause command
    elsif ["pause", "paws", "popeyes", "Paz", "pies", "pa"].include? entities[0]
      return {'command' => 'pause'}
    
    #check for resume command
    elsif ["resume", "play", "repeat"].include? entities[0]
      return {'command' => 'resume'}
    
    #check for wolfram alpha question
    elsif ["what", "ask", "what's"].include? entities[0]
        entities = entities[1..entities.length]
        question = entities.join(" ")
        #pods = WolframAlpha::Parser.new(question).pods
        pods = [OpenStruct.new(text: "all grades of gasoline | average price per gallon | Boulder, Colorado"), OpenStruct.new(text: "$3.571/gal  (US dollars per gallon)  (Monday, August 5, 2013)")]
        answer = self.process_wolfram_alpha_result(pods)
        return {'command' =>'ask', 'data' => answer }
    end
    
    return {"command" => "unknown"}

  end

  def is_command?
    first_word = command.split(" ")[0].downcase
    ["travis", "jarvis", "jaris", "javis"].include?(first_word) ? true : false
  end

  protected

  def process_wolfram_alpha_result(pods)
    humanify(pods[0].text) + " is " + humanify(pods[1].text)
  end

  def humanify(result)
    result = result.split("\/")
    return result[0] if result.length == 1

    new_result = ""

    result.each_with_index do |r, i|
      if i % 2 == 0
        new_result += r + " "
      elsif r.is_a?(Integer)
        new_result += "over " + r + " "
      else
        new_result += "per " + r + " "
      end

      return new_result
    end
  end



end