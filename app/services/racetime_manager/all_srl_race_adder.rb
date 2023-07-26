require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class AllSrlRaceAdder < ApplicationService
  # call with RacetimeManager::AllSrlRaceAdder.call

    # Script to populate SRL races with player, comment, placement, and goal 
    def call
      
      
      

      # load all SRL Races to an array
      race_array = []
      Race.all.each do |race|
        if race.url.include? "speedrun"
          race_array << race
        end
      end

      # get json for each race and convert to hash
      # "https://www.speedrunslive.com/api/pastresults/#{race.url[43,49]}")
      errors_array = []
      hash_hash = {}
      
      race_array.each do |race|
        puts "Adding #{race.url[43,49]}"
        hash_hash[race.id] = Util::JsonToHash.call("https://www.speedrunslive.com/api/pastresults/#{race.url[43,49]}")
        
      end

      # go through each race hash and import_race
      hash_hash.each_with_index do |(id, race_hash), _index|
        begin
        
        name = race_hash["data"]["game"]["gameName"]
        
        puts "Attempting to add race data for SRL Race: #{name}"
        RacetimeManager::ImportRaceFromSrl.call(id, race_hash)
        
        # If a name doesn't line up with something in the database, 
        # store it to be displayed at the end of the process
        rescue => e
          puts e.backtrace
          puts "Could not import #{name}"
          errors_array << name
          next
        end
      end
      errors_array.sort.each { |error| puts error }
    end



    private

    def add_to_race_hash(race_hash, races_array)
      race_hash.each { |race| races_array << race }
    end
  end
end