class PlayersController < ApplicationController

  def index
    @page_title = "All Players | N64Mania"
    @players = Player.all
    
    @players.each do |p|
      if p.stream.nil?
        p.stream = p.name.downcase!
       end
      p.stream.downcase!
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
