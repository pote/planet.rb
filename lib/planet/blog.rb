require 'sanitize'
require 'planet/post'
require 'planet/parsers'

class Planet
  class Blog

    attr_accessor :url,
                  :feed,
                  :type,
                  :name,
                  :author,
                  :image,
                  :twitter,
                  :posts,
                  :categories,
                  :tags,
                  :planet,
                  :rss_data

    def initialize(attributes = {})
      self.url        = attributes[:url]
      self.feed       = attributes[:feed]
      self.type       = attributes[:type]
      self.name       = attributes[:name]
      self.author     = attributes[:author]
      self.image      = attributes[:image]
      self.twitter    = attributes[:twitter]
      self.posts      = attributes.fetch(:posts, [])
      self.planet     = attributes[:planet]
      self.categories = attributes.fetch(:categories, '')
      self.tags       = attributes.fetch(:tags, '')

      # Feedzirra parsed data is  made available for when the information
      # provides is not enough. Transparency should help use cases we're
      # not considering.
      self.rss_data = nil

      # get parser-manager instance
      @parsers = Parsers.new
    end

    def fetch
      # given parser can be set arbitrarily with :type or inferred from the domain
      parser = self.type ? @parsers.get_parser(self.type) : @parsers.get_parser_for(self.feed)

      # parser instances should mimick Feedzirra interface
      parser.fetch_and_parse(self.feed,
                            :on_success => lambda { |url, feed| on_fetch_success(feed) },
                            :on_failure => lambda { |url, response| puts "\t=> Failed to fetch #{url.inspect} the server returned: #{response}" })
    end

    def on_fetch_success(feed)
      self.name ||= feed.title || 'the source'
      self.url  ||= feed.url

      if self.url.nil?
        abort "#{ self.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml"
      end

      self.rss_data = feed

      feed.entries.each do |entry|
        next unless whitelisted?(entry)
        content = if entry.content
                    self.sanitize_images(entry.content.strip)
                  elsif entry.summary
                    self.sanitize_images(entry.summary.strip)
                  else
                    abort "=> No content found on entry"
                  end

        if self.planet.config.fetch('sanitize_html', false)
            content = Sanitize.fragment(content, Sanitize::Config::RELAXED)
        end

        self.posts << @post = Post.new(
          title: entry.title.nil? ? self.name : entry.title,
          content: content,
          date: entry.published,
          url: entry.url,
          blog: self,
          categories: process_categories(entry.categories),
          rss_data: entry
        )

        puts "=> Found post titled #{ @post.title } - by #{ @post.blog.author }"
      end
    end

    def sanitize_images(html)
      ## We take all images with src not matching http refs and append
      ## the original blog to them.
      html.scan(/<img src="([^h"]+)"/).flatten.each do |img|
        if img[0] == '/'
          html.gsub!(img, "#{ self.url }#{ img }")
        else
          html.gsub!(img, "#{ self.url }/#{ img }")
        end
      end

      html
    end

    def process_categories(categories)
      categories.map { |category| category.downcase.gsub(/\s+/,'-').gsub(/[^a-z0-9\-_]/, '') }.join " "
    end

    def whitelisted?(entry)
      return true if self.planet.whitelisted_tags.empty?
      result = !(entry.categories & self.planet.whitelisted_tags).empty?
      puts "\t=> Ignored post titled: #{entry.title} with categories: [#{entry.categories.join(', ')}]" unless result
      result
    end
  end
end
