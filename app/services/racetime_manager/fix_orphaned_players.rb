require 'uri'
require 'net/http'

module RacetimeManager
  class FixOrphanedPlayers < ApplicationService

    # Write a different script to look at all races ever downloaded
    # and see if the number of entrants matches the number of Race.players.size

    def call()
      namco_url = "https://racetime.gg/n64mania/quick-conker-7808.json"
      cruis_url = "https://racetime.gg/n64mania/lawful-pommy-7866.json"

      namco_hash = Util::JsonToHash.call(namco_url)
      cruis_hash = Util::JsonToHash.call(cruis_url)

      hash_array = []

      hash_array << namco_hash
      hash_array << cruis_hash
      name_id_link = {}
      namco_name = "n64mania/quick-conker-7808"
      cruis_name = "n64mania/lawful-pommy-7866"

      name_id_link[namco_name] = 291
      name_id_link[cruis_name] = 290

      hash_array.each do |race_hash|
      entrants = race_hash["entrants"]
      race_id = name_id_link[race_hash["name"]]

      race = Race.find_by_id(race_id)

      begin
      entrants.each do |entrant|
        user = entrant["user"]
        plain_name = user["name"]
        twitch_name = user["twitch_name"]
        player = Player.find_by_name(entrant["user"]["name"])
        puts "Found #{player.name}" unless player.nil?
        if player.nil?
          new_player = Player.new
          new_player.name = plain_name
          new_player.stream = twitch_name
          new_player.save!
          player = new_player
        end
        placement_int = entrant["place"].nil? ? 0 : entrant["place"] 
        
        Placement.new(race_id: race_id, player_id: player.id, placement: placement_int, time: 0).save! unless Placement.where(race_id: race_id, player_id: player.id).exists?
      rescue => e
        puts e.message
        binding.pry
      end
      end
    end
    end
  end
end
