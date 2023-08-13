class AddDwRaces < ActiveRecord::Migration[6.0]
  def change
    array = ["https://racetime.gg/iateyourpies-discord-wars/salty-seto-8697/data"]
    array.each do |link|
      j = Util::JsonToHash.call(link)
      RacetimeManager::ImportRace.call(j)
    end
  end
end
