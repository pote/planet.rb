require 'feedjira'
require 'set'
require 'uri'

# Parsers class - manager for the feed parsers
#
# parser classes inherit from Planet::Parsers::BaseParser
# and are added automatically to the list of available parsers.
# files located on planet/parsers are automatically loaded.

class Planet::Parsers
  @@parsers = Set.new

  def self.add_parser(parser)
    @@parsers << parser
  end

  # Parser instances keep indexes of the available parsers and
  # check for duplicate definitions (need to use an instance
  # because #inherited gets called as soon as the class is seen
  # but before it is fully defined).
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

  # returns the appropiate parser based on the type
  def get_parser(type)
    begin
      return @types.fetch(type)
    rescue KeyError => e
      raise(ArgumentError, "No parser for type '#{ type }'", caller)
    end
  end

  # returns any parser that can handle this feeds' domain,
  # defaults to Feedjira if none available.
  def get_parser_for(feed)
    feed_domain = URI(feed).host

    @domains.each do |domain, parser|
      return parser if feed_domain.end_with? domain
    end

    return Feedjira::Feed # default generic parser
  end
end

# load parsers
dirname = File.join([File.dirname(__FILE__), 'parsers'])
Dir.open(dirname).each do |filename|
  require "#{dirname}/#{filename}" if filename.end_with? '.rb'
end
