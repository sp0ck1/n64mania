# generate_n64mania_races_import.rb

# copied from get_n64mania_metadata to start with
# Last update: October 31, 2022 @ 3:52 AM
# Convert this file to output a table of races data
# Need: 
#  a race id, 
#  the date, 
#  and the game id
# Can reference date from the JSON, but need to check individually afterward. Not ideal, but SRL does not have accurate dates. 
# Consider if it's worth it to write a function that finds the previous Friday for a given date.
# Game ID cross-reference hash is already written in, can fetch by game_ids_by_name[gameName] until refactored
# 
# Player duration to be stored in database as seconds
#  j = Time.iso8601("2022-10-01T01:37:27.382Z") has .hour .min and .sec for duration. need .hour * 60 * 60 for seconds, .min * 60 for seconds, + .sec
# 
# To convert epoch to datetime (with other available conversations on the resulting object before to_datetime): 
# 
# Time.at(epoch_no_quotation_marks).to_datetime

require 'csv'
require 'uri'
require 'net/http'
require 'json'
require 'pry'
require 'time'

class GenerateRaces
  # race_id = CSV.read("N64asCSV.csv")
  
  def output_csv(headers, data, name)
    CSV.open("#{name}.csv", 'wb') do |csv|
      csv << headers
  
      data.each do |column|
        csv << column
      end
    end
  end
  
  
  
  def run()
  
    # Get full stack of n64mania results, but 
    headers = %w{race_id date game_id}
    postgres_date_format = "%Y-%m-%d"
  
    arr = []
    arr2 = []
    comments_hash = {}
    games_hash = {}
    races_hash = {}
    players_hash = {}
    placements_hash = {}
    n64_csv = {}
    game_ids_by_name = {}

    db_race_id = "000"

    # Read list of all N64 Games and their n64mania game ids
    CSV.foreach("n64_games.csv", headers: true, col_sep: ",") do |row|
      row = row.to_h
      game_id = row["ID"]
      current_game_name = row["GAME"]
      publisher = row["PUBLISHER"]
      developer = row["DEVELOPER"]
      year = row["YEAR"]
  
      n64_csv[game_id] = {
        :game => current_game_name,
        :publisher => publisher,
        :developer => developer,
        :year => year
      }
  
      game_ids_by_name[current_game_name] = game_id
      
     
    end #CSV.foreach("n64_games.csv")
  
    CSV.foreach(("N64asCSV.csv"), headers: true, col_sep: ",") do |row|
          
      # For each row in CSV
      gameName = row["Game Name"] # Log the game name
      
      db_race_id = db_race_id.succ
    
      game_present = game_ids_by_name[gameName]

      # If the game name matches something in the official list of n64 games, store its official id
      # else, just store the name so it can be input manually
      if game_present 
        game_id = game_ids_by_name[gameName]
      else 
        game_id = gameName
      end 

      puts "Processing... #{gameName}"

      # If SRL ############################### SRL ################################### SRL ##############################
      if row["Race"].include? "speedrunslive" 
        race_id = row["Race"].chars.last(6).join # Get 6 character race ID
        
        puts 'SRL Race' 
        
        uri = URI("https://www.speedrunslive.com/api/pastresults/#{race_id}") 
        
        res = Net::HTTP.get_response(uri) 
        
        json = JSON.parse(res.body) # Parse the response JSON into hash
        
        ent = json['data']['entrants'] # ent is JSON "Entrants" array. 
  
        # raceDate returns an epoch by default. 
        # We convert the epoch to Ruby DateTime, then use strftime to put it in the postgres DATE format (yyyy-mm-dd)
        date = Time.at(json['data']['raceDate']).to_datetime.strftime(postgres_date_format)
  
        ent.each do |entry|
          playerName = entry['playerName'] # Log each player name, place, time, and comment
          place = entry['place']
          time = entry['time'] 
          comment = entry['message']
  
          arr << [game_id, date, gameName, playerName, place, time, comment,] # Log new line to CSV array

        end # end ent.each do |entry|

        arr2 << [db_race_id, date, game_id]
        # If Racetime ############################# RTGG ################################# RTGG ####################################
      elsif row["Race"].include? "racetime"
  
        race_id = row["Race"].partition('n64mania/').last # Get race slug
        puts 'RTGG Race'
        
        uri = URI("https://racetime.gg/n64mania/#{race_id}/data")
        res = Net::HTTP.get_response(uri)
        json = JSON.parse(res.body)
        date = Time.iso8601(json['opened_at']).to_datetime.strftime(postgres_date_format)
  
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

          arr << [game_id, date, gameName, playerName, place, time, comment,] # Log new line to CSV array
  
          
        end # end ent.each do |entry|
        arr2 << [db_race_id, date, game_id]
      end # end if ... elsif
     
    # Write headers and array to CSV
    output_csv(headers, arr2, "n64mania.import.races")
    end # end CSV.foreach ... do |row|
    
  end  # run()
  
  private
  
  def find_game_id_by_name(game_ids_by_name, current_game_name)
    notes = !(game_ids_by_name[current_game_name])
  end
  
  def iso8601_to_seconds(raw_duration)
    match = raw_duration.match(/P0DT(?:([0-9]*)H)*(?:([0-9]*)M)*(?:([0-9.]*)S)*/)
      hours   = match[1].to_i
      minutes = match[2].to_i
      seconds = match[3].to_f
      seconds + (60 * minutes) + (60 * 60 * hours)
  end

  def add_to_race_id()
    db_race_id = db_race_id.succ
  end

end
