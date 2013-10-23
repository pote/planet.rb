require File.join([File.dirname(__FILE__),'lib','planet','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'planet'
  s.version = Planet::VERSION
  s.author = 'PoTe'
  s.email = 'pote@tardis.com.uy'
  s.homepage = 'http://github.com/pote/planet.rb'
  s.platform = Gem::Platform::RUBY
  s.summary = 'An rss/atom feed aggregator designed to work with Octopress/Jekyll'
  s.files = Dir['bin/*'] + Dir['lib/**/*.rb']
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'planet'
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('feedzirra')
  s.add_runtime_dependency('mustache')
  s.add_runtime_dependency('box')
end
