class RacetimeManager::Errors::RaceImportError < StandardError
  attr_reader :game_name, :race_url 
  def initialize(message, game_name, race_url)
    @game_name = game_name
    @race_url = race_url
    super(message)
  end
end
