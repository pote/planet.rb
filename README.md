# Planet.rb

## Important!

This IS a work in progress, although the most functionality is already implemented, do not expect much stability, and of course patches are appreciated. :)

This gem is also **[gloriously untested](http://jamiesharpe.info/image/comics/haters/haters_gonna_hate3.jpg)** so I will assume that each time we use it a TDD enthusiast's head explodes. I expect, of course, to add some testing later, but for now I'd rather focus on functionality.

## What is this devilry?

An awesome RSS/Atom feed aggregator designed with Octopress/Jekyll in mind, it will parse a given
list of blogs and output them in a format suitable for usage with Octopress.

## Main Features

* Parse blogs, save posts as plain text files, ready to use with Octopress/Jekyll
* Filter posts by category, you might not want EVERY post in a given blog for your Planet (Not yet implemented, but should happen soon)

## Usage

So let's assume we have an [Octopress](http://octopress.org) blog. If you are not familiar with Octopress/Jekyll I suggest to check out its [documentation](http://octopress.org/docs/) before going any further.

 ▸ ls
 CHANGELOG.markdown README.markdown    config.rb          public
 Gemfile            Rakefile           config.ru          sass
 Gemfile.lock       _config.yml        plugins            source

Install the planet.rb gem

 ▸ gem install planet
 Successfully installed planet-0.0.1
 1 gem installed
 Installing ri documentation for planet-0.0.1...
 Installing RDoc documentation for planet-0.0.1...

We want to go to the source directory

  cd source

Were we will create a sample planet.yml config file

 ▸ planet init
 => created default planet.yml

You will most likely want to edit this yml file (unless you reallly really like me and [Cubox](http://cuboxlabs.com)!), after you are done, run the generate command.

 ▸ planet generate

 And that's it! your _posts directory should be populated with all relevant posts from the blogs you've configured, and  it's ready to be deployed. :)


## Jekyll Usage

You don't really need an explanation if you are using Jekyll, just initialize and generate the planet whenever you have your _posts directory and you'll be good to go :)
