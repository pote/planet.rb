require 'stringex_lite'
require 'mustache'

class Planet::Post

  attr_accessor :title, :content, :date, :url, :blog, :rss_data

  def initialize(attributes = {})
    self.title      = attributes[:title]
    self.content    = attributes[:content]
    self.date       = attributes[:date]
    self.url        = attributes[:url]
    self.blog       = attributes[:blog]
    self.rss_data   = attributes[:rss_data]
  end

  def to_s
    "#{ header }#{ content }#{ footer }"
  end

  def to_h
    {
      post_content: self.content,
      post_title: self.title,
      post_date: self.date,
      image_url: self.blog.image,
      author: self.blog.author,
      blog_url: self.blog.url,
      blog_name: self.blog.name,
      blog_slug: self.blog.name.to_url(:limit => 50, :truncate_words => true),
      blog_categories: self.blog.categories,
      blog_tags: self.blog.tags,
      post_url: self.url,
      twitter: self.blog.twitter,
      twitter_url: "http://twitter.com/#{ self.blog.twitter }",
      post_rss_data: self.rss_data,
      blog_rss_data: self.blog.rss_data
    }
  end

  alias_method :to_hash, :to_h

  def header
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

    [name_date, name_title].join('-')[0..59] # can return a file name that is too long, so truncate here to 60 chars
  end

end
