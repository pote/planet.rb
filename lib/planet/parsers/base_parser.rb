class Planet
  class Parsers
    # base class for feed parsers
    # subclasses should declare @type and @domains
    # and also mimick Feedzirra interface.
    class BaseParser
      def self.type
        @type
      end

      def self.domains
        @domains || []
      end

      def self.inherited(parser)
        Parsers.add_parser parser
      end

      def self.fetch_and_parse(feed)
        raise(Exception, "Not implemented", caller)
      end
    end
  end
end
