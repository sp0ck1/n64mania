require 'json'
require 'uri'
require 'net/http'
require 'pry'

module Util
  class JsonToHash < ApplicationService
    # call with Util::JsonToHash.call(json_url)
      
    def initialize(json_url)
      @json_url = json_url
    end

    def call()
      uri = URI(@json_url)
      res = Net::HTTP.get_response(uri)
      json = JSON.parse(res.body)
    end
  end
end