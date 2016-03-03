# Planet.rb

## Important!

This IS a work in progress, although most functionality is already implemented, do not expect much stability, and of course patches are appreciated. :)

This gem is also **[gloriously untested](https://camo.githubusercontent.com/47a95d835ab6fb66486fb17164fe091ed1ab007f/687474703a2f2f69313030312e70686f746f6275636b65742e636f6d2f616c62756d732f61663133382f637970636f64652f46756e6e7925323053747566662f6861746572735f676f6e6e615f68617465332e6a7067)** so I will assume that each time we use it a TDD enthusiast's head explodes. I expect, of course, to add some testing later, but for now I'd rather focus on functionality.

## What is this devilry?

An awesome RSS/Atom feed aggregator designed with [Octopress](http://octopress.org/)/[Jekyll](http://jekyllrb.com/) in mind, it will parse a given
list of blogs and output them in a format suitable for usage with these amazing blogging engines.

## Why?

* Most companies want a nice company blog with interesting stuff on it.
* Most coders will prefer to write on their own blogs, nobody wants to write interesting stuff on their company blog when they could write it on their own.
* planet.rb bridges that gap, your coders/designers/whatever can write on their own blogs, the company can have that content (with proper credits for the author, links to their blog and twitter).
* Everybody wins with minimum effort! Just set up an octopress blog, a cron job to regenerate it and you are done, the company has a stream of interesting content to show.

## Main Features

* Parse blogs, save posts as plain text files, ready to use with Octopress/Jekyll.
* Dead easy to set up.
* Can be used on a regular blog, to import posts from other blogs while maintaining proper credits to the original author.
* Completely unobstrusive, will not mess up your Octopress or Jekyll set up by changing files around.

## Basic Set Up

So let's assume we have an [Octopress](http://octopress.org) blog. If you are not familiar with Octopress/Jekyll I suggest to check out its [documentation](http://octopress.org/docs/) before going any further.


```bash
▸ ls
CHANGELOG.markdown README.markdown    config.rb          public
Gemfile            Rakefile           config.ru          sass
Gemfile.lock       _config.yml        plugins            source
```

Install the planet.rb gem

```bash
▸ gem install planet
Successfully installed planet-0.5.5
1 gem installed
Installing ri documentation for planet-0.5.5...
Installing RDoc documentation for planet-0.5.5...
```

Create a sample planet.yml config file

```bash
▸ planet init
=> Created default planet.yml
```

You will most likely want to edit this yml file (unless you reallly really like me and [Cubox](http://cuboxlabs.com)!), after you are done, run the generate command.

```bash
▸ planet generate
=> You are missing some files in your templates directory, planet.rb will create them for you - make sure to review them on source/_layouts/!
=> Created default source/_layouts/author.html
=> Created default source/_layouts/header.md
=> Parsing http://www.rss-specifications.com/blog-feed.xml
=> Found post titled Understanding RSS Feeds - by Sample: RSS Specifications
=> Found post titled Create an RSS Feed - by Sample: RSS Specifications
=> Found post titled Social Media in a recession, does it make financial sense? - by Sample: RSS Specifications
=> Found post titled Feds Launch Social Media Verification Registry - by Sample: RSS Specifications
=> Found post titled Kids, Safety and Social Media - by Sample: RSS Specifications
...
=> Parsing http://www.feedforall.com/sample.xml
=> Found post titled RSS Solutions for Restaurants - by Anonimus Author
=> Found post titled RSS Solutions for Schools and Colleges - by Anonimus Author
=> Found post titled RSS Solutions for Computer Service Companies - by Anonimus Author
=> Found post titled RSS Solutions for Governments - by Anonimus Author
=> Found post titled RSS Solutions for Politicians - by Anonimus Author
=> Found post titled RSS Solutions for Meteorologists - by Anonimus Author
=> Found post titled RSS Solutions for Realtors & Real Estate Firms - by Anonimus Author
=> Found post titled RSS Solutions for Banks / Mortgage Companies - by Anonimus Author
=> Found post titled RSS Solutions for Law Enforcement - by Anonimus Author
=> Writing 594 posts to the source/_posts/ directory.
```

And that's it! your source/_posts/ directory (or whatever you selected in your planet.yml file) should be populated with all relevant posts from the blogs you've configured, and  it's ready to be consumed by Octopress. :)

## planet.yml

The planet.yml file contains the basic config options for planet. It consists of some basic fields that need to be there, as well as some that can be simply ignored or just picked up from the feed. Namely

```yaml
planet:
    posts_directory: source/_posts/           # => Posts text files will be written into this directory
    templates_directory: source/_layouts/     # => Planet specific layouts will be saved here, I suggest that it matches your Octopress/Jekyll layout directory.
    whitelisted_tags: []                      # => Only posts that are tagged with any of these tags will be imported

blogs:
  - author: "Sample: RSS Specifications"                          # => Name that we will use as the author of this post
    feed:   "http://www.rss-specifications.com/blog-feed.xml"     # => RSS/Atom feed
    image:  "http://www.rss-specifications.com/rss-spec-rss.gif"  # => Image to use when doing credits

  - author:    "Anonimus Author"
    feed:      "http://www.feedforall.com/sample.xml"
    image:     "http://www.feedforall.com/ffalogo48x48.gif"
    categories: "programming"                 # => If you want to group your posts by categories or
    tags:      "test rss feed"                # => tag them, you can do that.
    twitter:   "poteland"                     # => Do you want a link to the user's twitter account next to the credits? You got it.
    url:       "http://www.feedforall.com/sample-feeds.htm" # => This is not needed in most cases, because it's picked up from the feed, but if it's not on the feed
                                                            #    then planet will ask you to specify it. :)

```

## Layouts

So this is pretty sweet: planet.rb doesn't really want to inject html and random stuff that you can't control into your posts, that's why it uses templates to handle the extra text (namely: the header and footer of each post). This files are by default created in source/_layouts, and this is the list of stuff you can dynamically put in there, along with what you would get form it on my own blog.

```mustache
   {{ post_title }}             # => "I Made a Pretty Gem - Planet.rb"
   {{ post_url }}               # => "http://poteland.com/blog/i-made-a-pretty-gem-planet-dot-rb/"
   {{ post_date }}              # => "2012-04-14 05:17:00 UTC"
   {{ post_content }}           # => "I’ve been hurting to write this ever since we had the idea of creating a Planet for Cubox..." (Continued)
   {{ blog_name }}              # => "This is where I tell you stuff"
   {{ blog_slug }}              # => "this-is-where-i-tell-you-stuff"
   {{ blog_url }}               # => "http://poteland.com/articles"
   {{ blog_categories }}        # => "programming planet"
   {{ blog_tags }}              # => "go ruby jekyll"
   {{ image_url }}              # => "http://poteland.com/images/site-logo.png"
   {{ author }}                 # => "Pablo Astigarraga"
   {{ twitter }}                # => "poteland"
   {{ twitter_url }}            # => "http://twitter.com/poteland"
```

So feel free to customize planet.rb layouts any way you see fit (but please don't take away the author.html file! You should definitely give credit to the author of hte post)

## Full automated setup

I never took the time to write properly about this, but the lovely people at [Nilenso Software](http://nilenso.com/) - who's [blog](http://blog.nilenso.com) is powered by planet.rb - wrote an [amazing blog post](http://blog.nilenso.com/blog/2013/09/16/octopress-planet-dot-rb-and-the-nilenso-blog/) explaining their setup and reasons to pick their stack.

If you are unsure of how planet.rb should be used make sure to check their blog post and setup, they have it figured out. :)


## Migrate your blog to Octopress using planet.rb!

I've written a brief [blog post](http://poteland.com/blog/migrate-your-blog-to-octopress-using-planet-dot-rb/) about how to do this. Works like a charm :).


## Contributors

* [Samus_](https://github.com/git2samus) - His work on planet.rb is being sponsored by [Globant](http://www.globant.com/)
