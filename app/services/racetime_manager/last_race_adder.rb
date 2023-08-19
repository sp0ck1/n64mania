require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class LastRaceAdder < ApplicationService
  # call with RacetimeManager::LastRaceAdder.call
  # No need for def intialize(url) because this service will fetch the latest race from racetime.gg/n64mania
  # Just leaving a def initialize here to remind myself that they exist
    def initialize
    end
    
    # Maybe we should have another service to add races as a whole, or something attached to the model. 
    # Something that takes a race id, a game id, an array of Player objects, an array of Comment objects, and an array of Placement objects 
    # It could be done by just giving the thing a game id and having it generate the race id, but I would like this new class to 
    #   not do more than take the information it's given and insert it once it's verified, not do any of that verification.

    # The first thing this should do is check if the race is already added.
    # If this is going to be a button and not a recurring job, it needs to return false if race exists
    # 
    # Also a big deal to remember: 
    # Racetime goal must match name exactly (downcased) or we will add duplicate records
    # Get race goal, and search db for game name. If not present, find closest match *that has not already been raced*
    def call
      recent_race_url = get_race_url 
      recent_race_hash = race_url_to_hash(recent_race_url)
      race_start = recent_race_hash["started_at"].to_time
      
      # This code is the code to add a race from a racetime.gg hash 
      # Don't go any further if the race already exists in the database
      unless Race.where(date: race_start).exists? 
        race_end = recent_race_hash["ended_at"].to_time
        race_duration = race_end - race_start # Duration in seconds

        game_name = recent_race_hash["goal"]["name"]
        game = Game.where('name LIKE ?', "%#{game_name}%").first # Being Proper probably means breaking this out into a method
        game_id = game.id
        new_race_id = Race.all.last.id + 1
        race_goal = recent_race_hash["info"]

        new_race = Race.new
        new_race.id = new_race_id
        new_race.date = race_start # Stored here as ISO-8601 start date
        new_race.game_id = game.id
        new_race.url = "https://racetime.gg#{recent_race_url}"
        new_race.duration = race_duration
        new_race.goal = race_goal
        # new_race.description = "This is where a description would go, if I had one"

        comments_arr = []
        placements_arr = []

        entrants = recent_race_hash["entrants"]
        entrants.each do |entrant|
          user = entrant["user"]

          plain_name = user["name"]
          twitch_name = user["twitch_name"]

          player = Player.where(stream: twitch_name).first
        
          # Create player if not exists 
          # It's fine if this happens and then the script fails, because it will just find the player next time.
          if player.nil?
            new_player = Player.new
            new_player.name = plain_name
            new_player.stream = twitch_name
            new_player.save!
            player = new_player
          end

          player_id = Player.where(stream: twitch_name).first.id
          placement_int = entrant["place"].nil? ? 0 : entrant["place"] 
          if entrant["has_comment"]
            comment_text = entrant["comment"]
            comments_arr << Comment.new(player_id: player.id, race_id: new_race.id, comment_text: comment_text)
          end


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

      
        # pass players hash to method to check the Player table and add anyone who isn't in
          # This should be a function of the Player model I think
          # 2/16/2023: This code is written above, but could be added to Race model if you wanted

      end# comments also have to be done as their own method
    end

    private

    def get_race_url
      # Get the most recent race url via the first object in the "races": [{ at racetime.gg https://racetime.gg/n64mania/races/data
      json = json_from_url("https://racetime.gg/n64mania/races/data")
      json["races"].first["url"]
    end

    def race_url_to_hash(url)
      race_json = json_from_url("https://racetime.gg#{url}/data") # (the / is part of recent_race_url incl. /data)
    end

    def json_from_url(url) # This one should be its own public service probably, in case I need it in other files
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      json = JSON.parse(res.body)
    end

    def iso8601_to_seconds(raw_duration)
      match = raw_duration.match(/P0DT(?:([0-9]*)H)*(?:([0-9]*)M)*(?:([0-9.]*)S)*/)
        hours   = match[1].to_i
        minutes = match[2].to_i
        seconds = match[3].to_f
        seconds + (60 * minutes) + (60 * 60 * hours)
    end
    
    

  end
end