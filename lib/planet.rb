require 'simple-rss'
require 'open-uri'

class Blog < Struct.new(:feed, :author, :image, :posts)
end

class Post < Struct.new(:title, :content, :date, :link, :blog)

  def to_hash
    {
      title: title,
      date: date.strftime('%Y-%m-%d %H:%M'),
      link: link,
      content: content,
      author: blog.author
    }
  end

  def header
    ## TODO: We need categories/tags
    "---
title: \"%{title}\"
kind: article
author: %{author}
created_at: %{date}
---
" % self.to_hash
  end

  def file_name
    name_date = date ? date.strftime('%Y-%m-%d') : nil
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
    @@_blogs.each do |blog|
      puts "=> parsing #{ blog.feed }"
      rss = SimpleRSS.parse open(blog.feed)
      rss.entries.each do |entry|
        @@_posts << @post = Post.new(
          entry.fetch(:title),
          entry.fetch(:content).strip,
          entry.fetch(:updated, nil),           # Yeah, I know, Im following the default octopress value for the date parameter.
          entry.fetch(:id, nil),                # Er, this is the full link to the article
          blog
        )

        blog.posts << @post
        puts "=> Found post titled #{ @post.title } - by #{ @post.blog.author }"
      end
    end
  end

  def write_posts
    Dir.mkdir("_posts") unless File.directory?("_posts")
    puts "=> Writing #{ posts.size } posts to the _posts directory"

    posts(filter: {date: true, order: :date}).each do |post|
      file_name = '_posts/'.concat post.file_name

      File.open(file_name + '.markdown', "w+") { |f|
        f.write(post.header)
        f.write(post.content)
        f.close
      }
    end
  end
end
