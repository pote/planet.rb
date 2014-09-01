require File.join([File.dirname(__FILE__),'lib','planet','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'planet'
  s.version = Planet::VERSION
  s.author = 'PoTe'
  s.email = 'pote@tardis.com.uy'
  s.homepage = 'http://github.com/pote/planet.rb'
  s.licenses = ['MIT']
  s.platform = Gem::Platform::RUBY
  s.summary = 'Feed aggregator for Octopress/Jekyll'
  s.description = <<-EOF
    A feed aggregator implementation intended to be used with Octopress/Jekyll
  EOF
  s.files = Dir['bin/*'] + Dir['lib/**/*.rb']
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'planet'
  s.add_runtime_dependency 'gli',       '~> 2.12',  '>= 2.12.0'
  s.add_runtime_dependency 'feedjira',  '~> 1.3',   '>= 1.3.1'
  s.add_runtime_dependency 'mustache',  '~> 0.99',  '>= 0.99.6'
  s.add_runtime_dependency 'box',       '~> 0.1',   '>= 0.1.1'
  s.add_runtime_dependency 'stringex',  '~> 2.5',   '>= 2.5.2'
  s.add_runtime_dependency 'sanitize',  '~> 3.0',   '>= 3.0.0'
end
