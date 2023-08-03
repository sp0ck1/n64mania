class PlayersController < ApplicationController

  def index
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
  end



end
