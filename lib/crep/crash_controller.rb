module Crep

    class CrashController

        def initialize(app_title, top, crash_source)
            @app_title = app_title
            @top = top
            @crash_source = crash_source

            @crash_source.configure()
        end

        # returns list of top crashes
        def top_crashes(version, build)
            crashes = @crash_source.crashes(@top, @app_title, version, build)
        end
    end

end