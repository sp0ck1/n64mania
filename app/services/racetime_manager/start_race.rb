require 'json'
require 'uri'
require 'net/https'
require 'pry'

module RacetimeManager
  class StartRace < ApplicationService

    def initialize(game_name, goal)
      if ENV['rtgg_token'].nil?
        raise StandardError.new "Racetime.gg token not set."
      else
        @rtgg_token = ENV['rtgg_token']
        @game_name = game_name
        @goal = goal
      end
    end

    def call
     begin

      n64maniaCategoryURL = 'https://racetime.gg/o/n64mania/'
      oAuth2Credential = @rtgg_token

      params = {
      
      :invitational => false,
      :unlisted => false,
      :start_delay => 15,
      :time_limit => 72,
      :streaming_required => false,
      :auto_start => true,
      :allow_comments => true,
      :allow_midrace_chat => true,
      :allow_nonentrant_chat => true,
      :chat_message_delay => 0,
      :custom_goal => @game_name,
      :info_bot => @goal
    }

    uri = URI(n64maniaCategoryURL + "startrace")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{oAuth2Credential}"
    req.set_form_data(params)
    
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end

    # race_url = JSON.parse(res.body)["callback_url"]
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      puts res['location']
      return "https://racetime.gg#{res['location']}"
    else
      raise StandardError.new "Cannot start race; racetime.gg returned #{res.body}"
    end

  rescue => e
    puts e
    binding.pry
    end
  end
  end
end
