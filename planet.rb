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
  end
end


__END__
<div class="author">
  <img src="%{avatar}"/>
</div>

# %{title}
- Post written by %{author} on %{date}, check it out his blog at <a href="%{link}"> his blog. </a>


%{content}
