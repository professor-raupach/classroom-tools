module Instructor::CourseSessionsHelper

    def outside_ohlone?(latitude, longitude)
      return false unless latitude && longitude

      latitude < 37.5240 || latitude > 37.5290 ||
        longitude < -121.9280 || longitude > -121.9210
    end


end
