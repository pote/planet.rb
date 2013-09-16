# Planet.rb

## Important!

This IS a work in progress, although most functionality is already implemented, do not expect much stability, and of course patches are appreciated. :)

This gem is also **[gloriously untested](http://jamiesharpe.info/image/comics/haters/haters_gonna_hate3.jpg)** so I will assume that each time we use it a TDD enthusiast's head explodes. I expect, of course, to add some testing later, but for now I'd rather focus on functionality.

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
Successfully installed planet-0.2.4
1 gem installed
Installing ri documentation for planet-0.2.4...
Installing RDoc documentation for planet-0.2.4...
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
=> Parsing http://blog.poteland.com/atom.xml
=> Found post titled I made a pretty gem - Planet.rb - by Pablo Astigarraga
=> Parsing http://blog.cuboxlabs.com/atom.xml
=> Found post titled Mozilla Developer Network Hack Day Montevideo 2012 - by Cubox
=> Found post titled Cubox brings back Ruby meetups to Montevideo - by Cubox
=> Found post titled We're hiring - by Cubox
=> Found post titled rubydeps - New gem by Cuboxer - by Cubox
=> Found post titled Cuboxers at wroc_love.rb in Poland - by Cubox
=> Found post titled Open Source Projects - by Cubox
=> Found post titled Machine learning in perspective - by Cubox
=> Found post titled Cubox on finances - by Cubox
=> Found post titled So what is Uruguay like? - by Cubox
=> Found post titled Supporting this weekend's Rails Bugmash - by Cubox
=> Found post titled One App in the App Store - by Cubox
=> Found post titled A new website - by Cubox
=> Found post titled Google Chrome OS: Obvious to the point of being boring. - by Cubox
=> Writing 14 posts to the source/_posts/ directory
```

And that's it! your source/_posts/ directory (or whatever you selected in your planet.yml file) should be populated with all relevant posts from the blogs you've configured, and  it's ready to be consumed by Octopress. :)

## planet.yml

The planet.yml file contains the basic config options for planet. It consists of some basic fields that need to be there, as well as some that can be simply ignored or just picked up from the feed. Namely

```yaml
planet:
    posts_directory: source/_posts/                 # => Posts text files will be written into this directory
    templates_directory: source/_layouts/       # => Planet specific layouts will be saved here, I suggest that it matches your Octopress/Jekyll layout directory.
    whitelisted_tags: []                                   # => Only posts that are tagged with any of these tags will be imported

blogs:
  - author: "Cubox"                                 # => Name that we will use as the author of this post (soon you wont have to specify this :)
    feed:   "http://blog.cuboxlabs.com/atom.xml"    # => RSS/Atom feed
    image:  "http://cubox-website.s3.amazonaws.com/i-work-at-cubox/i-work-at-cubox-badge-small.png"  # => Image to use when doing credits

  - author: "Pablo Astigarraga"
    feed:   "http://blog.poteland.com/atom.xml"
    image:  "http://poteland.com/images/avatars/red_mage.png"
    twitter: "poteland"                             # => Do you want a link to the user's twitter account next to the credits? You got it.
    url:    "http://blog.poteland.com"              # => This is not needed in most cases, because it's picked up from the feed, but if it's not on the feed
                                                    #    then planet will ask you to specify it. :)

```

## Layouts

So this is pretty sweet: planet.rb doesn't really want to inject html and random stuff that you can't control into your posts, that's why it uses templates to handle the extra text (namely: the header and footer of each post). This files are by default created in source/_layouts, and this is the list of stuff you can dynamically put in there, along with what you would get form it on my own blog.

```mustache
   {{ post_title }}             # => "I Made a Pretty Gem - Planet.rb"
   {{ post_url }}               # => "http://blog.poteland.com/blog/2012/04/14/i-made-a-pretty-gem-planet-dot-rb/"
   {{ post_date }}              # => "2012-04-14 05:17:00 UTC"
   {{ post_content }}           # => "I’ve been hurting to write this ever since we had the idea of creating a Planet for Cubox..." (Continued)
   {{ blog_name }}              # => "This is where I tell you stuff"
   {{ blog_url }}               # => "http://blog.poteland.com"
   {{ image_url }}              # => "http://poteland.com/images/avatars/red_mage.png"
   {{ author }}                 # => "Pablo Astigarraga"
   {{ twitter }}                # => "poteland"
   {{ twitter_url }}            # => "http://twitter.com/poteland"
```

So feel free to customize planet.rb layouts any way you see fit (but please don't take away the author.html file! You should definitely give credit to the author of hte post)

# In The wild

## planet.rb is used in the following websites (that I know of)

* [blog.cuboxlabs.com](http://blog.cuboxlabs.com) - Where it coexists with Cubox's own posts, it has at the time of this writing about double the content it would have without planet.rb :)


## Migrate your blog to Octopress using planet.rb!

I've written a brief [blog post](http://blog.poteland.com/blog/2012/04/20/migrate-your-blog-to-octopress-using-planet-dot-rb/) about how to do this. Works like a charm :).


## Contributors

* [Samus_](https://github.com/git2samus) - His work on planet.rb is being sponsored by [Globant](http://www.globant.com/)


# Sponsorship

This project is sponsored by the amazing people at [Cubox](http://cuboxlabs.com) that make it possible for me to work on this without dying of starvation, BIG THANKS to them! (oh, and their [blog](http://blog.cuboxlabs.com) uses planet.rb, too! ;) )

<div align="center">
    <a href="http://cuboxlabs.com">
        <img src="http://poteland.com/images/cubox-logo-web-transparent.png" alt="Available for Awesomeness"/>
    </a>
</div>
