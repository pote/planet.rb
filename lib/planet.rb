require 'feedzirra'
require 'mustache'

class Planet < Struct.new(:config, :blogs)

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
      feed = Feedzirra::Feed.fetch_and_parse(blog.feed)

      blog.name ||= feed.title || 'the source'
      blog.url ||= feed.url

      if blog.url.nil?
        abort "#{ blog.author }'s blog does not have a url field on it's feed, you will need to specify it on planet.yml"
      end

      feed.entries.each do |entry|
        blog.posts << @post = Post.new(
          title: entry.title.sanitize,
          content: entry.content.strip.gsub('<img src="', "<img src=\"#{ blog.url }"),    ## => I don't like this that much, move it away
          date: entry.published,                                                          ##    and check that it's needed post by post.
          url: blog.url + entry.url,
          blog: blog
        )

        puts "=> Found post titled #{ @post.title } - by #{ @post.blog.author }"
      end
    end
  end

  def write_posts
    posts_dir = self.config.fetch('posts_directory', '_posts')
    FileUtils.mkdir_p(posts_dir)
    puts "=> Writing #{ self.posts.size } posts to the #{ posts_dir } directory"

    self.posts.each do |post|
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
        twitter_url: "http://twitter.com/#{ self.blog.twitter }"
      }
    end

    def header
      ## TODO: We need categories/tags
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'header.md'
      file_contents = File.read(file)

      Mustache.render(file_contents, self.to_hash)
    end

    def file_name
      name_date = date ? date.strftime('%Y-%m-%d') : nil
      name_title = title.downcase.scan(/\w+/).join('-')

      [name_date, name_title].join('-')
    end

    def footer
      file = self.blog.planet.config.fetch('templates_directory', '_layouts/') + 'author.html'
      file_contents = File.read(file)

      Mustache.render(file_contents, self.to_hash)
    end

    def to_s
      "#{ header }#{ content }#{ footer }"
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
