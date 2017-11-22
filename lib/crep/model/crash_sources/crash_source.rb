require 'hockeyapp'

module Crep

  # This is an abstract class that defines the methods which subclasses must implement.
  class CrashSource

    # Necessary configuration of the subclass can happen here
    def configure
      raise 'CrashSource subclass has to implement the `configure` method.'
    end

    # The app method returns the app of the CrashSource
    def app
      raise 'CrashSource subclass has to implement the `app` method.'
    end

  end
end
