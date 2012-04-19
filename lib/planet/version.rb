module Planet
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 1

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end # Version

  VERSION = Version.to_s
end
