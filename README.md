# Planet.rb

** This IS a work in progress, most functionality is being implemented, I will release it as a gemwhenever the basic functions are ready. **

An awesome RSS/Atom feed aggregator designed with Octopress/Jekyll in mind, it will parse a given
list of blogs and output them in a format suitable for usage with Octopress.

## Main Features

* Parse blogs, save posts as plain text files.
* Filter posts by category, you might not want EVERY post in a given blog for your Planet
* Planet.rb is using [Undress](http://github.com/foca/undress) convert the html on the blogs to a more convenient format, initially I will work with markdown, but textile is already supported by Undress, and the gem is built to support additional adapters that you can write.
