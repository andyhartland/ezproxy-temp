module EZproxy
  module Loader
    # The base class for EZproxy stanza loaders
    class Base
      attr_accessor :transformer

      def initialize(transformer: nil, &block)
        self.transformer = transformer || block
      end

      def load(url)
        raise NotImplementedError
      end

      def stanza(url)
        value = load(url)
        transformer ? transformer.call(value) : value
      end
    end
  end
end