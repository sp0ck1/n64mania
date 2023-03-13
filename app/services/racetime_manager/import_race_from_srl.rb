require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class ImportRaceFromSrl < ApplicationService
    
    def initialize(race_hash)
      @race_hash = race_hash
    end

    def call()
      # . . . importing from SRL hash instead of RT . . .
      begin
        race_date = Time.at(@race_hash["raceDate"]).to_date
      # Need to map all player names from SRL to plain_names or stream_names first
      # https://www.speedrunslive.com/api/players/Pikapals to get via srl name

        unless Race.where(date:race_start).exists?
          entrants_hash = @race_hash["entrants"]
          race_duration = get_duration_from_entrants(entrants_hash)

        end
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
      
      # Check if channel name already in Players
      def validate_srl_name(channel)
        channel = case channel
        when "tapioca2000"
          "t2kbot"
        else channel
        end
        
        Player.find_by_stream(channel)
      end

      # Returns nil if no channel name
      def get_srl_channel_name(playerName)
        # player = entrant["playerName"] to get playerName
        player_hash = Util::JsonToHash.call("https://www.speedrunslive.com/api/players/#{playerName}")
        # Need handling if player has no stream
        channel = player_hash["data"]["channel"]
      end

  end
end
