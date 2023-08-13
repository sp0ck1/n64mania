require 'json'
require 'uri'
require 'net/http'
require 'pry'

module RacetimeManager
  class StartClient < ApplicationService

    def call
      uri = URI('https://racetime.gg/o/token')
      params = {
        "Accept" => "application/json", 
        "Content-Type" => "application/x-www-form-urlencoded",
        "client_id" => ENV['rtgg_client_id'],
        "client_secret" => ENV['rtgg_client_secret'],
        "grant_type" => "client_credentials"
      }
      res = Net::HTTP.post_form(uri, params)
      ENV["rtgg_token"] = JSON.parse(res.body)["access_token"]
      puts "Racetime.gg connection has been established."
    end
  end
end