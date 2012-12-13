require 'planet/version'
require 'planet/blog'
require 'planet/importer'

class Planet

  attr_accessor :config, :blogs

  def initialize(attributes = {})
    self.config = attributes[:config]
    self.blogs  = attributes.fetch(:blogs, []).map do |blog|
      Blog.new(
        feed:    blog['feed'],
        url:     blog['url'],
        author:  blog['author'],
        image:   blog['image'],
        posts:   [],
        planet:  self,
        twitter: blog['twitter']
      )
    end
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
    PostImporter.import(self)
  end
end
