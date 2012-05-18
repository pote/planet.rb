require File.join([File.dirname(__FILE__),'lib','planet','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'planet'
  s.version = Planet::VERSION
  s.author = 'Pablo Astigarraga'
  s.email = 'pote@tardis.com.uy'
  s.homepage = 'http://poteland.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'An awesome rss/atom feed aggregator designed to work with Octopress/Jekyll'
  s.files = Dir['bin/*'] + Dir['lib/**/*.rb']
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'planet'
  s.add_development_dependency('rake')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('feedzirra')
  s.add_runtime_dependency('mustache')
end
