require 'uri'
require 'nokogiri'
require 'net/http'

module Util
  class GetCasesFromArcadeArtwork < ApplicationService

    def call()

      (82230..82527).each do |i|
        uri = URI("https://www.arcadeartwork.org/picture.php?/#{i}/category/531")
        res = Net::HTTP.get_response(uri)
        doc = Nokogiri::HTML(res.body)

        dd = doc.css(".imageInfoTable").css("#File").css("dd")
        filename = dd.text

        dl_uri = URI("https://www.arcadeartwork.org/action.php?id=#{i}&part=e&download")
        res = Net::HTTP.get_response(dl_uri)
        File.open(filename, 'w') { |file| file.write(res.body.force_encoding(Encoding::UTF_8)) }
      end # do
    end # method
  end # class
end # module