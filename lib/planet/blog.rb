require 'planet/post'
require 'planet/parsers'

class Planet
  class Blog

    attr_accessor :url, :feed, :type, :name, :author, :image, :twitter, :posts, :planet, :custom_attributes

    def initialize(attributes = {}, planet)
      self.url = attributes['url']
      self.feed = attributes['feed']
      self.type = attributes['type']
      self.name = attributes['name']
      self.author = attributes['author']
      self.image = attributes['image']
      self.twitter = attributes['twitter']
      self.posts = attributes.fetch('posts', [])

      self.planet = planet

      self.custom_attributes = attributes

      # get parser-manager instance
      @parsers = Parsers.new
    end

    def fetch
      # given parser can be set arbitrarily with :type or inferred from the domain
      parser = self.type ? @parsers.get_parser(self.type) : @parsers.get_parser_for(self.feed)

      # parser instances should mimick Feedzirra interface
      feed = parser.fetch_and_parse(self.feed)

      self.name ||= feed.title || 'the source'
      self.url ||= feed.url

      if self.url.nil?
        abort "#{ self.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml"
      end

      feed.entries.each do |entry|
        content = if entry.content
                    self.sanitize_images(entry.content.strip)
                  elsif entry.summary
                    self.sanitize_images(entry.summary.strip)
                  else
                    abort "=> No content found on entry"
                  end

        self.posts << @post = Post.new(
          title: entry.title.nil? ? self.name : entry.title,
          content: content,
          date: entry.published,
          url: self.url + entry.url,
          blog: self
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
  end
end
