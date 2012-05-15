require 'planet/version'
require 'planet/blog'

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
end
