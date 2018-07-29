require 'nokogiri'
require 'open-uri'

require 'ezproxy/loader/base'

module EZproxy
  module Loader
    # Loads EZproxy stanzas from the OCLC database
    class OCLC < Base
      attr_accessor :section

      def initialize(section: 0, **kwargs, &block)
        super(**kwargs, &block)
        self.section = section
      end

      def load(url)
        doc = Nokogiri::HTML(open(url))
        stanza = doc.xpath("//pre")
        stanza = stanza && stanza[section] ? stanza[section].content : nil
        title = doc.at_xpath('//h1[@id="title"]')
        title = title ? title.content : nil
        last_updated = doc.at_xpath('//span[@class="mt-last-updated"]')
        last_updated = last_updated ? last_updated['data-timestamp'] : nil
        Stanza.new(last_updated: last_updated, source: url, stanza: stanza, title: title)
      rescue StandardError => e
        nil
      end
    end
  end
end