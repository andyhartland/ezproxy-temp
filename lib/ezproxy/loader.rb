require 'uri'

require 'ezproxy/loader/file'
require 'ezproxy/loader/oclc'

module EZproxy
  # Methods and classes for loading EZproxy stanzas from various sources
  module Loader
    @loaders = {}

    def self.load(url, loader = nil)
      loader ||= loader_for_url(url)
      loader.load(url)
    end

    def self.loader_for_url(url)
      return @loaders[url] if @loaders.key?(url)
      uri = URI(url)
      return EZproxy::Loader::File.new if uri.scheme == 'file'
      return EZproxy::Loader::OCLC.new if oclc_uri?(uri)
      nil
    end

    def self.set_loader_for_url(url, loader = nil)
      if loader
        @loaders[url] = loader
      else
        @loaders.delete(url)
      end
    end

    def self.oclc_uri?(uri)
      return false unless uri.scheme == 'http' || uri.scheme == 'https'
      return false unless uri.host.end_with?('.oclc.org')
      true
    end
  end
end