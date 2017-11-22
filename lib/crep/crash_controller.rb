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
            $logger.debug("Showing top crashes for #{@crash_source.app.bundle_identifier}")
            crashes = @crash_source.crashes(@top, version, build)
            show_crashes(crashes)
        end

        def show_crashes(crashes)
            crashes.each do |crash|
                show_crash(crash)
            end
        end

        def show_crash(crash)
            $logger.debug("Occurrences: #{crash.occurrences}")
            $logger.debug("File/Line: #{crash.file_line}")
          end
    end

end