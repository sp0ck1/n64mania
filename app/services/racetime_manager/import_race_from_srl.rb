require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class ImportRaceFromSrl < ApplicationService
    
    def initialize(id, race_hash)
      @id = id
      @race_hash = race_hash
    end

    def call()
      # . . . importing from SRL hash instead of RT . . .
      puts "Importing race from SRL"
      data = @race_hash["data"]
      entrants_hash = data["entrants"]
      race_duration = get_duration_from_entrants(entrants_hash)
      begin

      # Need to map all player names from SRL to plain_names or stream_names first
      # https://www.speedrunslive.com/api/players/Pikapals to get via srl name
      # Maybe just import everybody and if there are duplicates then merge them later
      # merge(player_name_array, final_player_name) and that will take one of the two player_ids
      # and update the other player names with that player id, and also check any other place
      # there is a player_id in the db and replace the old id with the final_player_name's id
        
        race_date = Time.at(data["raceDate"]).to_date
        
        
        # Handle race - get goal & duration, players & their time & their comment
        
        race_goal = data["raceGoal"]
        race = Race.find(@id)
        race.duration = race_duration
        race.goal = race_goal
        race.save!

        comments_arr = []
        placements_arr = []

        entrants_hash.each do |entrant|
          user = entrant["playerName"]
          user = validate_srl_name(user)
          place = entrant["place"]
          comment_text = entrant["message"] # nil if no comment
          time = entrant["time"] == -1 ? 0 : entrant["time"] # set time to 0 (forfeit) if SRL reports -1

          player = Player.where("lower(name) = ?", user.downcase).first
          
          if player.nil?
            new_player = Player.new
            new_player.name = user
            new_player.stream = user
            new_player.save! 
            player = new_player
          end

          placement = Placement.new
          placement.race_id = @id
          placement.player_id = player.id
          placement.placement = place
          placement.time = time
          placement.save!

          comment = Comment.new
          comment.player_id = player.id
          comment.race_id = race.id
          comment.comment_text = comment_text
          comment.save!
        end

      rescue => e
        # binding.pry
      end
    end

    
    private
      
      def get_duration_from_entrants(entrants_hash)
        last_duration = 0
        entrants_hash.each do |entrant|
          unless entrant["time"] == -1
            last_duration = entrant["time"]
          end  
        end  
        last_duration
      end

      def get_unique_players_from_srl_urls
        player_set = Set.new
        Race.all.each do |race|
          if race.url.include? "speedrunslive"  
            race_json = Util::JsonToHash.call("https://www.speedrunslive.com/api/pastresults/#{race.url[43,49]}")    
            entrants = race_json["data"]["entrants"]    
            entrants.each { |entrant| player_set.add(entrant["playerName"]) }    
          end  
        end
        player_set
      end
      
      # Account for accts with different names (frann/fawn, chibieris/chibiluon)
      def validate_srl_name(user)
        user = case user
        when "tapioca2000"
          "tapioca"
        when "ChibiLuon"
          "ChibiEris"
        when "frann"
          "Fawn"
        when "kaitoumonkey"
          "Kaitou_Monkey"
        when "kyu"
          "Kyurize"
        when "Vandal00"
          "Vandal"
        when "vs_deluge"
          "VioletEtheree"
        else user
        end
        
        user
      end

      # Returns nil if no channel name
      def get_srl_channel_name(playerName)
        # player = entrant["playerName"] to get playerName
        player_hash = Util::JsonToHash.call("https://www.speedrunslive.com/api/players/#{playerName}")
        # Need handling if player has no stream
        channel = player_hash["data"]["channel"]
      end


  end # class
end # module

