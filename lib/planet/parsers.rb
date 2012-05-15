require 'feedzirra'

class Planet
  class Parsers
    @@parsers = []

    def self.get_parser(type)
      @@parsers.each do |parser|
        return parser if parser.type == type
      end

      raise ArgumentError, "no parser for type '#{ type }'", caller
    end

    def self.get_parser_for(feed)
      feed_domain = URI(feed).host

      @@parsers.each do |parser|
        return parser if parser.domains.any? { |domain| feed_domain.end_with? domain }
      end

      return Feedzirra::Feed
    end
  end
end
