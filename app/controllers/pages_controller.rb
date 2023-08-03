class PagesController < ApplicationController

  def index
    # Directs to views/pages/index.html.erb
    @races = Race.all.sort
    @games = Game.pluck(:name).sort
    @players = Player.all
    @unplayed = Game.unplayed

    @page_title = "N64Mania"
    @page_description = "N64Mania home page."
  end  

  # Parses search from the search bar on the homepage. 
  # Currently only accepts game search, but javascript library allows keys for other types
  # Would like to add Player search as well
  def parse_search
    search_text = params[:autoComplete]
    potential_game = Game.where(name: search_text) # Renders an empty array if no results

    if potential_game.empty?
      render html: "Sorry, this isn't a valid game."
    else 
      redirect_to game_path(potential_game.first.id)
    end
  end
end

