require 'date'
require 'json'

require 'ezproxy/loader'

module EZproxy
  # Represents an EZproxy configuration stanza
  class Stanza
    attr_accessor :last_updated, :source, :stanza, :title

    def initialize(last_updated: nil, source: nil, stanza: nil, title: nil)
      self.last_updated = last_updated
      self.source = source
      self.stanza = stanza
      self.title = title
    end

    def <<(line)
      stanza.concat(parse_stanza(line))
    end

    def last_updated=(value)
      @last_updated = if value.is_a?(String)
                        Date.strptime(value[0..10], '%Y-%m-%d')
                      elsif value.is_a?(Date)
                        value
                      elsif value.is_a?(DateTime)
                        value.date
                      end
    end

    def stanza=(value)
      @stanza = value.nil? || value.empty? ? [] : parse_stanza(value)
    end

    def to_json
      JSON.dump(to_h)
    end

    def to_h
      {
        last_updated: last_updated,
        source: source,
        stanza: stanza,
        title: title
      }
    end

    def to_s
      return '' if @stanza.nil? || @stanza.empty?
      stanza_s = @stanza.join("\n")
      "##begin\n#{@stanza}\n##end"
    end

    private

    def line_sep
      "\n"
    end

    def parse_stanza(value)
      value.split(line_sep).delete_if { |value| value.nil? || value.empty? }
    end
  end
end