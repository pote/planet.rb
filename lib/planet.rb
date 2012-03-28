require 'simple-rss'
require 'nokogiri'
require 'open-uri'

BLOGS = [
  {
    feed:   'http://blog.cuboxlabs.com/atom.xml',
    author: 'Cubox',
    image:  'http://cuboxlabs.com/img/cubox-humans/could-be-you.png',
    file_extension: '.html'
  },
  {
    feed:   'http://feeds.feedburner.com/picandocodigo',
    author: 'Fernando Briano',
    image:  'http://www.gravatar.com/avatar/49c5bd577a2d7ef0628c8ceb90b8c7ae?s=128&d=identicon&r=PG',
    file_extension: '.md'
  }
]

class Blog < Struct.new(:feed, :author, :image, :file_extension, :posts)
end

class Post < Struct.new(:title, :content, :date, :link, :blog)

  def to_hash
    {
      title: title,
      date: date,
      link: link,
      content: content,
      author: blog.author
    }
  end

  def header
    ## TODO: We need categories/tags
    "---
      title: %{title}
      kind: article
      author: %{author}
      created_at: %{date}
---
    " % self.to_hash
  end

  def file_name
    name_date = if date
                  [date.year, date.month, date.day].join('-')
                else
                  ''
                end

    name_title = title.downcase.scan(/\w+/).join('-')

    [name_date, name_title].join('-')
  end
end

class Planet

  def initialize
    @@_posts = []
    @@_blogs = []
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

  def blogs
    @@_blogs
  end

  def aggregate
    BLOGS.each do |blog|
      @@_blogs << @blog = Blog.new(
        blog[:feed],
        blog[:author],
        blog[:image],
        blog[:file_extension],
        []
      )

      rss = SimpleRSS.parse open(@blog.feed)
      rss.entries.each do |entry|
        @@_posts << @post = Post.new(
          entry.fetch(:title),
          entry.fetch(:content),
          entry.fetch(:updated, nil),           # Yeah, I know, Im following the default octopress value for the date parameter.
          entry.fetch(:id, nil),                # Er, this is the full link to the article
          @blog
        )

        @blog.posts << @post
      end
    end
  end

  def write_posts
    Dir.mkdir("_posts") unless File.directory?("_posts")

    posts(filter: {date: true, order: :date}).each do |post|
      file_name = '_posts/'.concat post.file_name

      File.open(file_name + post.blog.file_extension, "w+") { |f|
        f.write(post.header)
        f.write(post.title)
        f.write(post.content)
        f.close
      }
    end
  end
end
