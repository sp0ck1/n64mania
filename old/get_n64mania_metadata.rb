# get_ids.rb

require 'csv'
require 'uri'
require 'net/http'
require 'json'
require 'pry'
require 'time'

# race_id = CSV.read("N64asCSV.csv")

def output_csv(headers, data)
  CSV.open('N64ManiaRaces.csv', 'wb') do |csv|
    csv << headers

    data.each do |column|
      csv << column
    end
  end
end

def iso8601_to_seconds(raw_duration)
  match = raw_duration.match(/P0DT(?:([0-9]*)H)*(?:([0-9]*)M)*(?:([0-9.]*)S)*/)
    hours   = match[1].to_i
    minutes = match[2].to_i
    seconds = match[3].to_f
    seconds + (60 * minutes) + (60 * 60 * hours)
end

def run()

  # Get full stack of n64mania results, but 
  headers = %w{Game Player Place Time Comment}
  arr = []

  comments_hash = {}
  games_hash = {}
  races_hash = {}
  players_hash = {}
  placements_hash = {}
  

  n64_csv = {}
  game_names = {}
  CSV.foreach("n64_games.csv", headers: true, col_sep: ",") do |row|
    row = row.to_h
    game_id = row["ID"]
    game_name = row["GAME"]
    publisher = row["PUBLISHER"]
    developer = row["DEVELOPER"]
    year = row["YEAR"]

    n64_csv[game_id] = {
      :game => game_name,
      :publisher => publisher,
      :developer => developer,
      :year => year
    }

    game_names[game_name] = game_id
    
    binding.pry
  end


  CSV.foreach(("N64asCSV.csv"), headers: true, col_sep: ",") do |row|
        
    # For each row in CSV
    gameName = row["Game Name"] # Log the game name
  
    if row["Race"].include? "speedrunslive" # If Race field has SpeedRunsLive
      race_id = row["Race"].chars.last(6).join # Get 6 character race ID
      puts 'SRL Race' # Log that it's an SRL race
      
      uri = URI("https://www.speedrunslive.com/api/pastresults/#{race_id}") # Create URI Object w/ SRL API & Race ID
      
      res = Net::HTTP.get_response(uri) # Make the HTTP request 
      
      json = JSON.parse(res.body) # Parse the response JSON into hash
      
      ent = json['data']['entrants'] # ent is JSON "Entrants" array. 
      
      ent.each do |entry|
        playerName = entry['playerName'] # Log each player name, place, and comment
        place = entry['place']
        time = entry['time'] ###### TODO: Make sure this is in seconds
        comment = entry['message']
        
        puts "Game: #{gameName}"
        puts "Place: #{place}"
        puts "Player: #{playerName}"
        puts "Time: #{time}"
        puts "Comment: #{comment}"
        
       arr << [game_id, gameName, playerName, place, time, comment, notes] # Log new line to CSV array
      end # end ent.each do |entry|
    
    elsif row["Race"].include? "racetime"

      race_id = row["Race"].partition('n64mania/').last # Get race slug
      puts 'RTGG Race'
      
      uri = URI("https://racetime.gg/n64mania/#{race_id}/data")
      res = Net::HTTP.get_response(uri)
      json = JSON.parse(res.body)
        
      ent = json['entrants']
      ent.each do |entry|
        playerName = entry['user']['name']
        place = entry['place_ordinal']
        time = 0
        unless entry['finish_time'].nil?
          time = iso8601_to_seconds(entry['finish_time'])
        end
        comment = entry['comment']
        
        puts "Game: #{gameName}"
        puts "Place: #{place}"
        puts "Player: #{playerName}"
        puts "Time: #{time}"
        puts "Comment: #{comment}"
        
        notes = verify_game_name

        arr << [game_id, gameName, playerName, place, time, comment, notes] # Log new line to CSV array
      end # end ent.each do |entry|
    end # end if ... elsif
      
  # Write headers and array to CSV
  output_csv(headers, arr)
  end # end CSV.foreach ... do |row|
  
end  # run()

private

def verify_game_name(game_names, current_game_name)
  if !(game_names[current_game_name])
    # if game name is not in the game names, make note of it
    notes = "Cannot fetch id. Game is not in game_names list. Check for other spellings."
  else 
    game_id = game_names[current_game_name]
    notes = ""
  end
  notes
end