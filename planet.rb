require 'simple-rss'
require 'nokogiri'
require 'open-uri'
require 'ruby-debug'



class Post < Struct.new(:title, :content, :date, :link, :blog)
end

class Blog < Struct.new(:feed, :author, :image, :posts)
end

BLOGS = [
  {
    feed:   'http://blog.cuboxlabs.com/atom.xml',
    author: 'Cubox',
    image:  'http://cuboxlabs.com/img/cubox-humans/could-be-you.png'
  },
  {
    feed:   'http://feeds.feedburner.com/picandocodigo',
    author: 'Fernando Briano',
    image:  'http://www.gravatar.com/avatar/49c5bd577a2d7ef0628c8ceb90b8c7ae?s=128&d=identicon&r=PG'
  }
]

class Planet

  def initialize
    @@_posts = []
    @@_blogs = []
  end

  def posts
    @@_posts
  end

  def blogs
    @@_blogs
  end

  def aggregate 
    BLOGS.each do |blog|
      @@_blogs  << @blog = Blog.new(
        blog[:feed],
        blog[:author],
        blog[:image],
        []
      )

      rss = SimpleRSS.parse open(@blog.feed)
      rss.entries.each do |entry|
        @@_posts << @post = Post.new(
          entry.fetch(:title),
          entry.fetch(:content),
          entry.fetch(:updated, nil),           # Yeah, I know
          entry.fetch(:id, nil),                # I KNOW!
          @blog
        )

        @blog.posts << @post
      end
    end

    debugger

    order_posts

    @@_posts.each { |p| puts p.title }
  end

  def order_posts
    with_date = @@_posts.keep_if { |p| !p.date.nil? }
    without_date = @@_posts.keep_if { |p| p.date.nil? }

    with_date.sort_by! { |p| p.date }

    debugger
    @@_posts = with_date + without_date
  end
end


__END__
<div class="author">
  <img src="%{avatar}"/>
</div>

# %{title}
- Post written by %{author} on %{date}, check it out his blog at <a href="%{link}"> his blog. </a>


%{content}
