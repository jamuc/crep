module Crep

  # This is an abstract class that defines the methods which subclasses must implement.
  class CrashSource

    attr_reader :app

    # Necessary configuration of the subclass can happen here
    def configure(bundle_identifier)
      raise 'CrashSource subclass has to implement the `configure` method.'
    end
  end
end
