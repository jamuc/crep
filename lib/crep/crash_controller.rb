module Crep

    class CrashController

        def initialize(bundle_identifier, top, crash_source)
            @bundle_identifier = bundle_identifier
            @top = top
            @crash_source = crash_source

            @crash_source.configure(bundle_identifier)
        end

        # returns list of top crashes for the given build
        def top_crashes(version, build)
            XINGLogger.debug("Reporting top #{@top} crash groups for #{@crash_source.app.name} (#{version}/#{build}) #{@crash_source.app.bundle_identifier}")
            crashes = @crash_source.crashes(@top, version, build)
            show_crashes(crashes)
        end

        def show_crashes(crashes)
            crashes.each do |crash|
                show_crash(crash)
            end
        end

        def show_crash(crash)
            XINGLogger.debug("Occurrences: #{crash.occurrences}")
            XINGLogger.debug("File/Line: #{crash.file_line}")
            XINGLogger.debug("Reason: #{crash.reason[0..80]}")
            XINGLogger.debug("Class: #{crash.crash_class}")
          end
    end

end