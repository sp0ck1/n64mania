class PlayersController < ApplicationController

  def index
    @page_title = "All Players | N64Mania"
    
    case params[:sort_order]
      when "ascending"
        case params[:sort]
          when "name"
            @players = Player.all.sort_by { |player| player.name }
          when "num_races"
            @players = Player.all.sort_by { |player| player.races.size }
          when "last_race"
            @players = Player.all.sort_by { |player| player.races.order(:date).last.game.name }
          else 
            @players = Player.all.sort_by { |player| player.races.size }
        end
      when "descending"
        case params[:sort]
          when "num_races"
            @players = Player.all.sort_by { |player| player.races.size }.reverse
          when "last_race"
            @players = Player.all.sort_by { |player| player.races.order(:date).last.game.name }.reverse
          when "name"
            @players = Player.all.sort_by { |player| player.name }.reverse
          end
        else 
          @players = Player.all.sort_by { |player| player.races.size }.reverse
    end
    
    @players.each do |p|
      if p.stream.nil?
        p.stream = p.name
       end

    end

    
    @players 
  end
  
  def show
    @player = Player.find(params[:id])
    @races = []
    @player.placements.each { |placement| @races << Race.find_by_id(placement.race_id) }
    @races.sort_by(&:date)

    @page_title = "#{@player.name} | N64Mania"
    @page_description = "#{@player.name}'s N64Mania player page."
  end



end
