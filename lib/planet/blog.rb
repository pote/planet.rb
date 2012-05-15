require 'planet/post'
require 'planet/parsers'

class Planet
  class Blog

    attr_accessor :url, :feed, :type, :name, :author, :image, :twitter, :posts, :planet

    def initialize(attributes = {})
      self.url = attributes[:url]
      self.feed = attributes[:feed]
      self.type = attributes[:type]
      self.name = attributes[:name]
      self.author = attributes[:author]
      self.image = attributes[:image]
      self.twitter = attributes[:twitter]
      self.posts = attributes.fetch(:posts, [])
      self.planet = attributes[:planet]
    end

    def fetch
      parser = self.type ? Parsers.get_parser(self.type) : Parsers.get_parser_for(self.feed)

      feed = parser.fetch_and_parse(self.feed)

      self.name ||= feed.title || 'the source'
      self.url ||= feed.url

      if self.url.nil?
        abort "#{ self.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml"
      end

      feed.entries.each do |entry|
        content = if !entry.content.nil?
                    self.sanitize_images(entry.content.strip)
                  elsif !entry.summary.nil?
                    self.sanitize_images(entry.summary.strip)
                  else
                    abort "=> No content found on entry"
                  end

        title = if !entry.title.nil?
                  entry.title.sanitize
                else
                  self.name
                end

        self.posts << @post = Post.new(
          title: title,
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
