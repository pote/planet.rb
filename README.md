# Planet.rb

## Important!

This IS a work in progress, although most functionality is already implemented, do not expect much stability, and of course patches are appreciated. :)

This gem is also **[gloriously untested](http://jamiesharpe.info/image/comics/haters/haters_gonna_hate3.jpg)** so I will assume that each time we use it a TDD enthusiast's head explodes. I expect, of course, to add some testing later, but for now I'd rather focus on functionality.

## What is this devilry?

An awesome RSS/Atom feed aggregator designed with Octopress/Jekyll in mind, it will parse a given
list of blogs and output them in a format suitable for usage with these amazing blogging engines.

## Main Features

* Parse blogs, save posts as plain text files, ready to use with Octopress/Jekyll.
* Filter posts by category, you might not want EVERY post in a given blog for your Planet (Not yet implemented, but should happen soon).
* Immediately makes you a better person.

## Usage

So let's assume we have an [Octopress](http://octopress.org) blog. If you are not familiar with Octopress/Jekyll I suggest to check out its [documentation](http://octopress.org/docs/) before going any further.


```shell
▸ ls
CHANGELOG.markdown README.markdown    config.rb          public
Gemfile            Rakefile           config.ru          sass
Gemfile.lock       _config.yml        plugins            source
```

Install the planet.rb gem

```shell
▸ gem install planet
Successfully installed planet-0.0.1
1 gem installed
Installing ri documentation for planet-0.0.1...
Installing RDoc documentation for planet-0.0.1...
```

Were we will create a sample planet.yml config file

```shell
▸ planet init
=> created default planet.yml
```

You will most likely want to edit this yml file (unless you reallly really like me and [Cubox](http://cuboxlabs.com)!), after you are done, run the generate command.

```shell
▸ planet generate
=> You are missing some files in your templates directory, planet.rb will create them for you - make sure to review them on source/_layouts/!
=> Created default source/_layouts/author.html
=> Created default source/_layouts/header.md
=> Parsing http://blog.poteland.com/atom.xml
=> Found post titled I made a pretty gem - Planet.rb - by Pablo Astigarraga
=> Parsing http://blog.cuboxlabs.com/atom.xml
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
=> Writing 13 posts to the source/_posts/ directory
```

And that's it! your source/_posts/ directory (or whatever you selected in your planet.yml file) should be populated with all relevant posts from the blogs you've configured, and  it's ready to be consumed by Octopress. :)

## Jekyll Usage

You don't really need an explanation if you are using Jekyll, just initialize and generate the planet whenever you have your _posts directory and you'll be good to go :)
