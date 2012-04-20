require 'feedzirra'
require 'mustache'

class Planet

  def initialize(config = {})
    @@_posts = []
    @@_blogs = []

    @@_config = config
  end

  def config
    @@_config
  end

  def blogs
    @@_blogs
  end

  def posts(options = {})
    return @@_posts unless options[:filter]

    filtered_posts = @@_posts

    filtered_posts = case options[:filter][:date]
                     when true
                       filtered_posts.reject { |p| p.date.nil? }
                     when false || nil
                       filtered_posts.reject { |p| !p.date.nil? }
                     else
                       filtered_posts
                     end

    filtered_posts = case options[:filter][:order]
                     when :date
                       with_date = filtered_posts.reject { |p| p.date.nil? }
                       without_date = filtered_posts.reject { |p| !p.date.nil? }

                       with_date.sort_by { |po| po.date }.reverse + without_date
                     else
                       filtered_posts
                     end

    filtered_posts
  end

  def aggregate
    @@_blogs.each do |blog|
      puts "=> Parsing #{ blog.feed }"
      feed = Feedzirra::Feed.fetch_and_parse(blog.feed)

      blog.name ||= feed.title || 'the source'
      blog.url ||= feed.url
      raise "#{ blog.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml" if blog.url.nil?

      feed.entries.each do |entry|
        @@_posts << @post = Post.new(
          title: entry.title.sanitize,
          content: entry.content.strip.gsub('<img src="', "<img src=\"#{ blog.url }"),
          date: entry.published,
          url: blog.url + entry.url,
          blog: blog
        )

        blog.posts << @post
        puts "=> Found post titled #{ @post.title } - by #{ @post.blog.author }"
      end
    end
  end

  def write_posts
    posts_dir = @@_config.fetch('posts_directory', '_posts')
    Dir.mkdir(posts_dir) unless File.directory?(posts_dir)
    puts "=> Writing #{ posts.size } posts to the #{ posts_dir } directory"

    posts(filter: {date: true, order: :date}).each do |post|
      file_name = posts_dir + post.file_name

      File.open(file_name + '.markdown', "w+") { |f| f.write(post.to_s) }
    end
  end

  class Post < Struct.new(:title, :content, :date, :url, :blog)

    def initialize(attributes = {})
      self.title = attributes.fetch(:title, nil)
      self.content = attributes.fetch(:content, nil)
      self.date = attributes.fetch(:date, nil)
      self.url = attributes.fetch(:url, nil)
      self.blog = attributes.fetch(:blog, nil)
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
        twitter_uri: "http://twitter.com/#{ self.blog.twitter }"
      }
    end

    def header
      ## TODO: We need categories/tags
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'header.md'
      file_contents = File.open(file, 'r').read

      Mustache.render(file_contents, self.to_hash)
    end

    def file_name
      name_date = date ? date.strftime('%Y-%m-%d') : nil
      name_title = title.downcase.scan(/\w+/).join('-')

      [name_date, name_title].join('-')
    end

    def footer
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'author.html'
      file_contents = File.open(file, 'r').read

      Mustache.render(file_contents, self.to_hash)
    end

    def to_s
      self.header + self.content + self.footer
    end
  end

  class Blog < Struct.new(:url, :feed, :name, :author, :image, :twitter, :posts, :planet)

    def initialize(attributes = {})
      self.url = attributes[:url]
      self.feed = attributes[:feed]
      self.name = attributes[:name]
      self.author = attributes[:author]
      self.image = attributes[:image]
      self.twitter = attributes[:twitter]
      self.posts = attributes.fetch('posts', [])
      self.planet = attributes[:planet]
    end
  end
end
