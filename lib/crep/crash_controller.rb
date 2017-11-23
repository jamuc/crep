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

      total_crashes = @crash_source.crash_count(version: version,
                                                build: build)
      show_crashes(crashes: crashes, total_crashes: total_crashes)
    end

    def show_crashes(crashes:, total_crashes:)
      crashes.each do |crash|
        percentage = crash_percentage(crash: crash, total_crashes: total_crashes)
        show_crash(crash: crash, percentage: percentage)
      end
    end

    def crash_percentage(crash:, total_crashes:)
      crash.occurrences.to_f / total_crashes.to_f * 100.0
    end

    def show_crash(crash:, percentage:)
      XINGLogger.debug("Class: #{crash.crash_class}")
      XINGLogger.debug("Occurrences: #{crash.occurrences}")
      XINGLogger.debug("Percentage: #{percentage}")
      XINGLogger.debug("File/Line: #{crash.file_line}")
      XINGLogger.debug("Reason: #{crash.reason[0..80]}")
      end
  end
end
