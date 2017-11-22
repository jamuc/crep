module Crep

    class CrashController

        def initialize(bundle_identifier, top, crash_source)
            @bundle_identifier = bundle_identifier
            @top = top
            @crash_source = crash_source

            @crash_source.configure(bundle_identifier)
        end

        # returns list of top crashes
        def top_crashes(version, build)
            $logger.debug(@crash_source.app.bundle_identifier)
            crashes = @crash_source.crashes(@top, version, build)
        end
    end

end