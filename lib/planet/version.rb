class Planet
  module Version
    MAJOR = 0
    MINOR = 5
    PATCH = 2

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end

  VERSION = Version.to_s
end
