require 'colorize'

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
      CrepLogger.info("Reporting for #{app_name} (#{version}/#{build}) #{identifier}")

      crash_reports = crashes_report(crashes: crashes, total_crashes: total_crashes, version: version)
      empty_message = total_crashes == 0 ? "Look mom, no crashes... yet!" : "Look mom, no unresolved crashes... yet!"
      CrepLogger.info(empty_message) if crash_reports.empty?

      crash_reports.each_with_index do |crash_report, i|
        puts("\n------------- ##{(i + 1)} --------------")
        crash_report.each do |line|
          puts(line)
        end
      end
    end

    def crashes_report(crashes:, total_crashes:, version:)
      crashes.map do |crash|
        percentage = crash_percentage(crash: crash, total_crashes: total_crashes)
        crash_report(crash: crash, percentage: percentage, version: version)
      end
    end

    def crash_percentage(crash:, total_crashes:)
      crash.occurrences.to_f / total_crashes.to_f * 100.0
    end

    def crash_report(crash:, percentage:, version:)
      raise 'Crash info does not fulfill the requirements' unless crash.is_a? Crep::Crash
      report = []
      report.push "Class: #{crash.crash_class}"
      report.push "First appeared on #{crash.registered_at} and occurred #{crash.occurrences} times in #{version}"
      report.push "Percentage: #{percentage.round(2)}% of all #{version} crashes"
      report.push "File/Line: #{crash.file_line}"
      report.push "Reason: #{crash.reason}" # crash.reason[0..80]
      report.push "Link: #{crash.url}"
      report
    end
  end
end
