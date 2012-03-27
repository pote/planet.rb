require './lib/planet'


desc 'Instanciate Planet and write posts to _posts directory'
task :planetize do
  planet = Planet.new

  planet.aggregate

  planet.write_posts
end
