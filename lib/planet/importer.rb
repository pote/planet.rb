class PlanetPostImporter

  def self.import(config)

    planet = Planet.new(config)

    planet.aggregate

    yield(planet)

  end

end
