class PlayersController < ApplicationController

  def index
    player_names = []
    @players = []
    Player.all.each do |player|
      player_names << player.name
    end
    #TODO: Sort names on Player page in alphabetical order regardless of downcase
    player_names.sort!
    
    player_names.each do |name|
      @players << Player.find_by_name(name)
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
