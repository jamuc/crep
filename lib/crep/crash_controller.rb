module Crep
  class CrashController
    def initialize(bundle_identifier, top, crash_source, show_only_unresolved)
      @bundle_identifier = bundle_identifier
      @top = top
      @crash_source = crash_source
      @show_only_unresolved = show_only_unresolved

      @crash_source.configure(bundle_identifier)
    end

    # returns list of top crashes for the given build
    def top_crashes(version, build)
      crashes = @crash_source.crashes(@top, version, build, @show_only_unresolved)

      total_crashes = @crash_source.crash_count(version: version,
                                                build: build)
      report(crashes: crashes,
             total_crashes: total_crashes,
             app_name: @crash_source.app.name,
             identifier: @crash_source.app.bundle_identifier,
             version: version,
             build: build)
    end

    def report(crashes:, total_crashes:, app_name:, identifier:, version:, build:)
      puts("Reporting for #{app_name} (#{version}/#{build}) #{identifier}")

      crash_reports = crashes_report(crashes: crashes, total_crashes: total_crashes, version:version)
      crash_reports.each_with_index { |crash_report, i|
        puts ""
        puts("------------- ##{(i+1).to_s} --------------")
        crash_report.each { |line|
          puts(line)
        }
      }

    end

    def crashes_report(crashes:, total_crashes:, version:)
      crashes.map { |crash|
        percentage = crash_percentage(crash: crash, total_crashes: total_crashes)
        crash_report(crash: crash, percentage: percentage, version: version)
      }
    end

    def crash_percentage(crash:, total_crashes:)
      crash.occurrences.to_f / total_crashes.to_f * 100.0
    end

    def crash_report(crash:, percentage:, version:)
      report = []
      report.push "Class: #{crash.crash_class}"
      report.push "Occurrences: #{crash.occurrences}"
      report.push "Percentage: #{percentage.round(2)}% of all #{version} crashes"
      report.push "File/Line: #{crash.file_line}"
      report.push "Reason: #{crash.reason}" #crash.reason[0..80]
      report
      end
  end
end
