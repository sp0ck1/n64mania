require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class ImportRace < ApplicationService
    # Only works for Racetime.gg races. Do not rename. 
    # Naming is because this will be the default way to import a race going forward

    # call with RacetimeManager::ImportRace.call(race_hash)
      
    def initialize(race_hash)
      @race_hash = race_hash
    end

    def call()
      begin
      new_players = {}
      race_start = @race_hash["started_at"].to_time
      race_end = @race_hash["ended_at"].to_time
      race_duration = race_end - race_start # Duration in seconds

        game_name = Util::ValidateGameName.call(@race_hash["goal"]["name"])
        new_players[game_name] = []
        game =  Game.where('name ILIKE ?', "%#{game_name}%").first # Being Proper probably means breaking this out into a method
        # binding.pry
      unless game.id.nil?
        unless Race.where(duration: race_duration,game_id: game.id).exists? # will only import races that do not already exist
          
          # Handle race
          game_id = game.id
          new_race_id = Race.last.id + 1
          race_goal = @race_hash["info"]
          race_url_snippet = @race_hash["url"]
          new_race = Race.new
          new_race.id = new_race_id
          new_race.date = race_start # Stored here as ISO-8601 start date
          new_race.game_id = game.id
          new_race.url = "https://racetime.gg#{race_url_snippet}"
          new_race.duration = race_duration
          new_race.goal = race_goal
          # new_race.description = "This is where a description would go, if I had one"

          comments_arr = []
          placements_arr = []

          entrants = @race_hash["entrants"]
          entrants.each do |entrant|
            user = entrant["user"]

            plain_name = user["name"]
            twitch_name = user["twitch_name"]

            player = Player.where(name: plain_name).first # If stream = nil, defaults to first nil stream. Cannot add new players this way if they do not have a stream. TODO!!!!
          
            # Handle players
            # It's fine if this happens and then the script fails, because it will just get the player next time.
            if player.nil?
              puts "Adding player #{plain_name}"
              new_player = Player.new
              new_player.name = plain_name
              new_player.stream = twitch_name
              new_player.save!
              player = new_player
              new_players[game.name] << player.name
            end

            placement_int = entrant["place"].nil? ? 999 : entrant["place"] 
            if entrant["has_comment"]
              comment_text = entrant["comment"]

              comment = Comment.new
              comment.player_id = player.id
              comment.race_id = new_race.id
              comment.comment_text = comment_text
              comments_arr << comment
            end

            # Handle placements
            placement = Placement.new
            placement.race_id = new_race.id
            placement.player_id = player.id
            placement.placement = placement_int
            placement.time = 0
            # binding.pry
            # Duration in seconds. 
            # Common parlance refers to this as one's "time," but the length of the whole race is the duration for the purposes of the Race model.
            placement.time = iso8601_to_seconds(entrant["finish_time"]) unless placement.placement == 999
            placements_arr << placement
          end

          new_race.save!
          comments_arr.each { |comment| comment.save! }
          placements_arr.each { |placement| placement.save! }
          puts "#{game_name} import complete"
        else puts "#{game_name} race of duration #{race_duration} already exists! Skipping ..."
          
        end
      end # end unless game.id.nil?

    rescue => e
      puts e.message # undefined method `id' for nil:NilClass, the original e.message
      raise "Exception in race importer! Could not import #{@race_hash["url"]}" # The e.message the user sees
    ensure
      
     
    end
    
    new_players # 
    end # end def

  private

    # Accepts a value in the form of "P0DT03H37M04.727456S" and attempts to transform it into total seconds
    def iso8601_to_seconds(raw_duration)
      match = raw_duration.match(/P0DT(?:([0-9]*)H)*(?:([0-9]*)M)*(?:([0-9.]*)S)*/)
      hours   = match[1].to_i
      minutes = match[2].to_i
      seconds = match[3].to_f
      seconds + (60 * minutes) + (60 * 60 * hours)
    
    end

    def validate_name(game_name)
      game_name = case game_name
      when "Olympic Hockey '98 (Nagano)" # RT name
        "Olympic Hockey Nagano '98" # DB name
      when "World Cup '98"
        "World Cup 98"
      when "Pokemon Stadium 2"
        "Pokémon Stadium 2"
      when "Pokemon Stadium"
        "Pokémon Stadium"
      when "Castlevania 64"
        "Castlevania" 
      when "Superman 64"
        "Superman" 
      when "Hercules: The Legendary Adventures"
        "Hercules: The Legendary Journeys"
      when "Star Wars: Episode 1: Racer" 
        "Star Wars Episode I: Racer"
      when "Paper Mario Part 3" 
        "Paper Mario"
      when "Paper Mario Part 2"
        "Paper Mario" 
      when "Paper Mario (chapters 1-4)"
        "Paper Mario" 
      when "Midway's Greatest Arcade Hits Vol.1"
        "Midway's Greatest Arcade Hits: Volume 1"
      when "NFL Quarterback Club 2001"
        "NFL QB Club 2001"
      when "MRC: Multi Racing Championship" 
        "MRC: Multi-Racing Championship"
      when "Wave Race 64: All Championships"
        "Wave Race 64"
      when "Finish Episode 5"
        "Tetrisphere"
      when "Rampage: World Tour"
        "Rampage World Tour" 
      when "Star Wars Episode I: Battle for Naboo"
        "Star Wars: Episode I: Battle for Naboo"
      when "Clayfighter: Sculptor's Cut"
        "ClayFighter Sculptor's Cut"
      when  "Clayfighter 63 1/3"
        "ClayFighter 63⅓"
      when "All Star Baseball '99"
        "All-Star Baseball 99"
      when "Tom & Jerry in: Fists of Furry"
        "Tom and Jerry in Fists of Furry"
      when "AeroFighters Assault"
        "Aero Fighters Assault"
      when "San Francisco Rush: Extreme Racing USA"
        "San Francisco Rush: Extreme Racing"
      when "Madden '99"
        "Madden NFL 99"
      when "Worms: Armageddon"
        "Worms Armageddon"
      when "Ken Griffey Jr.'s Slugfest"
        "Ken Griffey, Jr.'s Slugfest"
      when "Shadow Man: Beat first boss?"
        "Shadow Man"
      when "Hybrid Heaven: Beat Area 2"
        "Hybrid Heaven"
      when "Twisted Edge: Extreme Snowboarding"
        "Twisted Edge Extreme Snowboarding"
      else game_name
      end
      game_name
    end
  end
end