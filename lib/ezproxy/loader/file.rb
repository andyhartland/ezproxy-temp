require 'open-uri'
require 'uri'

require 'ezproxy/loader/base'

module EZproxy
  module Loader
    # Load EZproxy stanzas from an EZproxy configuration file
    class File < Base
      attr_accessor :include

      def initialize(include: true)
        self.include = include
      end

      def load!(url)
        @stanzas = {}
        uri = URI(url)
        open(url) { |file| load_file(file, url) }
      end

      private

      def add_stanza(stanza = nil)
        @stanzas[stanza.title] = stanza if stanza
      end

      def new_stanza(current_stanza = nil, source = nil, title = nil)
        add_stanza(current_stanza)
        EZproxy::Stanza.new(source: source, title: title)
      end

      def load_file(file, source = nil)
        seen_begin = false
        stanza = EZproxy::Stanza.new(source: source)
        file.each do |line|
          keyword, params = line.split(' ', 2)
          next if keyword.nil? || keyword.empty?
          keyword.downcase!
          if keyword == '##begin'
            stanza = new_stanza(stanza, source, params)
            seen_begin = true
          elsif keyword == '##end'
            add_stanza(stanza)
            stanza = nil
            seen_begin = false
          elsif keyword == 'title'
            stanza = new_stanza(stanza, source, params) unless seen_begin
            stanza.title = params
            stanza << line
          else
            stanza << line
          end
        end
      end
    end
  end
end