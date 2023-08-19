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
      errors_hash = {}
      new_players = []
      initial_result = Util::JsonToHash.call("https://racetime.gg/n64mania/races/data?show_entrants=1")
      num_pages = initial_result["num_pages"]

      add_to_race_hash(initial_result["races"], hash_array)

      (2..num_pages).each_with_index do |page_number| 
        puts "Adding page number #{page_number}"
        result = Util::JsonToHash.call("https://racetime.gg/n64mania/races/data?show_entrants=1&page=#{page_number}")
        add_to_race_hash(result["races"], hash_array)
      end # end do
      
      hash_array.each_with_index do |race_hash|
        begin
        puts "Adding #{race_hash["goal"]["name"]}"
        to_add = RacetimeManager::ImportRace.call(race_hash)
        new_players << to_add unless to_add.first[1].empty?

        # If a name doesn't line up with something in the database, 
        # store it to be displayed at the end of the process
        rescue => e
          puts e.message
          name = race_hash["goal"]["name"]
          puts "Could not import #{name}"
          errors_hash[name] = e.message
          next
        end # end begin
      end # end do
      errors_hash.sort.each { |game, message| puts "#{game}: #{message}" }
      puts "New players: #{new_players}"
      # TODO: Add new races output as well
    end # end def



    private

    def add_to_race_hash(race_hash, races_array)
      race_hash.each { |race| races_array << race }
    end
  end # end class
end # end module