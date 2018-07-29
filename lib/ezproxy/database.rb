require 'nokogiri'
require 'open-uri'

require 'ezproxy/loader'

module EZproxy
  # Represents the OCLC database of EZproxy stanzas
  class Database
    URL = 'https://help.oclc.org/Library_Management/EZproxy/Database_stanzas'.freeze
    XPATH = '//div[@id="section_1"]/div/ul/li/a'.freeze

    def initialize
      load!
    end

    def empty?
      @stanzas.empty?
    end

    def length
      @stanzas.length
    end

    def load!
      @stanzas = {}
      Nokogiri::HTML(open(URL)).xpath(XPATH).each do |e|
        @stanzas[e.content] = e['href']
      end
    rescue StandardError => e
      nil
    end

    def [](title)
      source = @stanzas[title]
      return nil unless source
      EZproxy::Loader.load(source)
    end
  end
end