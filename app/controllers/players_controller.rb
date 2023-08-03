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
    @placements_including_player = Placement.where(player_id: @player.id)
    @races = []
    @placements_including_player.each { |placement| @races << Race.find_by_id(placement.race_id) }
    @races.sort_by(&:date)
    
  end



end
