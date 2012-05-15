require 'feedzirra'
require 'mustache'
require 'planet/version'

class Planet

  attr_accessor :config, :blogs

  def initialize(attributes = {})
    self.config = attributes[:config]
    self.blogs = attributes.fetch(:blogs, [])
  end

  def posts
    self.blogs.map { |b| b.posts }.flatten
  end

  def aggregate
    self.blogs.each do |blog|
      puts "=> Parsing #{ blog.feed }"
      blog.fetch
    end
  end

  def write_posts
    posts_dir = self.config.fetch('posts_directory', 'source/_posts/')
    FileUtils.mkdir_p(posts_dir)
    puts "=> Writing #{ self.posts.size } posts to the #{ posts_dir } directory."

    self.posts.each do |post|
      file_name = posts_dir + post.file_name

      File.open(file_name + '.markdown', "w+") { |f| f.write(post.to_s) }
    end
  end

  class Post

    attr_accessor :title, :content, :date, :url, :blog

    def initialize(attributes = {})
      self.title = attributes[:title]
      self.content = attributes[:content]
      self.date = attributes[:date]
      self.url = attributes[:url]
      self.blog = attributes[:blog]
    end

    def to_s
      "#{ header }#{ content }#{ footer }"
    end

    def to_hash
      {
        post_content: self.content,
        post_title: self.title,
        post_date: self.date,
        image_url: self.blog.image,
        author: self.blog.author,
        blog_url: self.blog.url,
        blog_name: self.blog.name,
        post_url: self.url,
        twitter: self.blog.twitter,
        twitter_url: "http://twitter.com/#{ self.blog.twitter }"
      }
    end

    def header
      ## TODO: We need categories/tags
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'header.md'
      file_contents = File.read(file)

      Mustache.render(file_contents, self.to_hash)
    end

    def footer
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'author.html'
      file_contents = File.read(file)

      Mustache.render(file_contents, self.to_hash)
    end

    def file_name
      name_date = date ? date.strftime('%Y-%m-%d') : nil
      name_title = title.downcase.scan(/\w+/).join('-')

      [name_date, name_title].join('-')
    end

  end

  class Blog

    attr_accessor :url, :feed, :name, :author, :image, :twitter, :posts, :planet

    def initialize(attributes = {})
      self.url = attributes[:url]
      self.feed = attributes[:feed]
      self.name = attributes[:name]
      self.author = attributes[:author]
      self.image = attributes[:image]
      self.twitter = attributes[:twitter]
      self.posts = attributes.fetch(:posts, [])
      self.planet = attributes[:planet]
    end

    def fetch
      feed = Feedzirra::Feed.fetch_and_parse(self.feed)

      self.name ||= feed.title || 'the source'
      self.url ||= feed.url

      if self.url.nil?
        abort "#{ self.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml"
      end

      feed.entries.each do |entry|
        ## TODO: I should probably consider using feed 'adapters' for specific
        ## blog engine feeds that don't have their stuff on the standard fields.
        ## Example: blogspot has the content on "summary" instead of content ¬¬.
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
