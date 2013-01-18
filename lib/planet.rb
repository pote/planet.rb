require 'yaml'
require 'planet/version'
require 'planet/blog'
require 'planet/importer'

class Planet

  attr_accessor :config, :blogs

  def initialize(config_file_path)
    config_file = read_config_file(config_file_path)
    self.config = config_file[:planet]
    self.blogs  = config_file[:blogs]
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
    Importer.import(self)
  end

  private

  def read_config_file(config_file_path)
    config = YAML.load_file(config_file_path)
    planet = config.fetch('planet', {})
    blogs = config.fetch('blogs', []).map do |blog|
      Blog.new(blog, self)
    end

    { planet: planet, blogs: blogs }
  end
end
