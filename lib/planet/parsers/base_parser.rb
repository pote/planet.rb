class Planet
  class Parsers
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
