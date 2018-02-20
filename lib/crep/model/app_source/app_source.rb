# frozen_string_literal: true

module Crep
  class AppSource
    attr_reader :version

    def configure
      CrepLogger.info('Configuration of the CrashSource can happen in the `configure` method')
    end

    def apps
      raise 'AppSource subclass has to implement the `apps` method.'
    end

    # versions returns the versions for the given app identifier
    def versions(_app_identifier)
      raise 'AppSource subclass has to implement the `versions` method.'
    end
  end
end
