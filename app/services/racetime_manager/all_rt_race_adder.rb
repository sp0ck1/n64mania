require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class AllRtRaceAdder < ApplicationService
  # call with RacetimeManager::AllRtRaceAdder.call

    def call
      # script to get through every n64mania race and get all URLs from racetime
      
      # load all pages 
      # "https://racetime.gg/n64mania/races/data?page=#{page_number}"

      # get a race hash for each

      # go through each race hash and import_race

      hash_array = []
      errors_array = []
      initial_result = Util::JsonToHash.call("https://racetime.gg/n64mania/races/data?show_entrants=1")
      num_pages = initial_result["num_pages"]

      add_to_race_hash(initial_result["races"], hash_array)

      (2..num_pages).each_with_index do |page_number| 
        puts "Adding page number #{page_number}"
        result = Util::JsonToHash.call("https://racetime.gg/n64mania/races/data?show_entrants=1&page=#{page_number}")
        add_to_race_hash(result["races"], hash_array)
      end
      
      hash_array.each_with_index do |race_hash|
        begin
        puts "Adding #{race_hash["goal"]["name"]}"
        RacetimeManager::ImportRace.call(race_hash)
        
        # If a name doesn't line up with something in the database, 
        # store it to be displayed at the end of the process
        rescue
          name = race_hash["goal"]["name"]
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