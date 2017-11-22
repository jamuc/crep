require 'hockeyapp'

module Crep

  class CrashSource

    def configure
      raise 'CrashSource subclass has to implement the `configure` method.'
    end

  end
end
