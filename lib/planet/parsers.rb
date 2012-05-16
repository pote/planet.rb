require 'feedzirra'
require 'set'

class Planet
  class Parsers
    @@parsers = Set.new

    def self.add_parser(parser)
      @@parsers << parser
    end

    def initialize
      @types, @domains = {}, {}

      @@parsers.each do |parser|
        new_type, new_domains = parser.type, parser.domains

        fail("duplicate type") if new_type and @types.has_key? new_type
        fail("overlapping domains") unless (@domains.keys & new_domains).empty?

        @types[new_type] = parser if new_type
        new_domains.each do |new_domain|
          @domains[new_domain] = parser
        end
      end
    end

    def get_parser(type)
      begin
        return @types.fetch(type)
      rescue KeyError => e
        raise(ArgumentError, "No parser for type '#{ type }'", caller)
      end
    end

    def get_parser_for(feed)
      feed_domain = URI(feed).host

      @domains.each do |domain, parser|
        return parser if feed_domain.end_with? domain
      end

      return Feedzirra::Feed # default generic parser
    end
  end
end

# load parsers
dirname = File.join([File.dirname(__FILE__), 'parsers'])
Dir.open(dirname).each do |filename|
  require "#{dirname}/#{filename}" if filename.end_with? '.rb'
end
