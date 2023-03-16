class PlayersController < ApplicationController

  def index
    @players = Player.all.sort_by(&:name)
  end
  
  def show
    @player = Player.find(params[:id])

    @placements_including_player = Placement.where(player_id: @player.id)
    @races = []
    @placements_including_player.each { |placement| @races << Race.find_by_id(placement.race_id) }
    @races.sort_by(&:date)
    
  end



end
