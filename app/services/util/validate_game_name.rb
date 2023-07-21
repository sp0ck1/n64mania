require 'pry'

module Util
  class ValidateGameName < ApplicationService
    # call with Util::ValidateGameName.call(name)

    def initialize(name)
      @game_name = name
    end

    def call()
      @game_name = case @game_name
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
      else game_name
      end
      game_name
    end

  end
end
