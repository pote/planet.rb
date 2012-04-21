module Planet
  module Version
    MAJOR = 0
    MINOR = 3
    PATCH = 3

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end

  VERSION = Version.to_s
end
