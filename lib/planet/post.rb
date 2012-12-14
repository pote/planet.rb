require 'mustache'

class Planet::Post

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
