module Crep
    class AppSource
    attr_reader :version

        def configure()
            CrepLogger.info("Configuration of the CrashSource can happen in the `configure` method")
        end

        def apps()
            raise 'AppSource subclass has to implement the `apps` method.'
        end
    end

end