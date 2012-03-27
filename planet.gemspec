require './lib/planet'

Gem::Specification.new do |s|
  s.name              = 'planet'
  s.version           = '0.1'
  s.date              = '2012-03-27'
  s.summary           = 'RSS/Atom feed aggregator'
  s.homepage          = "http://github.com/pote/planet.rb"
  s.email             = "pote@tardis.com.uy"
  s.authors           = ["Pablo Astigarraga"]
  s.has_rdoc          = false
  s.require_path      = "lib"
  s.files            += Dir.glob("lib/**/*")
  s.add_dependency      'nokogiri'
  s.add_dependency      'simple-rss'
  s.description       = <<-desc
    Inspired by planetplanet.org's (horribly outdated but) functional planet project. Planet.rb will generate markdown files for the posts in the blogs you select, intended for use with Jekyll or Octopress.
  desc
end
