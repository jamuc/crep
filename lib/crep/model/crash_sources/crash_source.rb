module Crep
  # This is an abstract class that defines the methods which subclasses must implement.
  class CrashSource
    attr_reader :app

    # Necessary configuration of the subclass can happen here
    def configure(_bundle_identifier)
      raise 'CrashSource subclass has to implement the `configure` method.'
    end

    def crash_count(_version, _build)
      raise 'CrashSource subclass has to implement the `crash_count` method.'
    end

    def crashes(_top, _version, _build, _show_only_unresolved)
      raise 'CrashSource subclass has to implement the `crashes` method.'
    end
  end
end
