require 'crep/model/crash_sources/crash_source'
require 'crep/model/crash_model/app'
require 'crep/model/crash_model/crash'
require 'hockeyapp'

module Crep
  # The HockeyApp Crash Source
  class HockeyAppCrashSource < CrashSource
    def configure(bundle_identifier)
      HockeyApp::Config.configure do |config|
        raise 'Missing API token (CREP_HOCKEY_API_TOKEN)' unless token = ENV['CREP_HOCKEY_API_TOKEN']
        config.token = token
      end

      @client = HockeyApp.build_client
      @hockeyapp_app = hockeyapp(bundle_identifier, @client)
      @app = App.new(@hockeyapp_app.title, bundle_identifier)
    end

    def crashes(top, version, build, show_only_unresolved)
      version = version(version: version, build: build)

      crash_groups(version, show_only_unresolved).take(top.to_i)
    end

    def crash_count(version:, build:)
      statistics = @client.get_statistics @hockeyapp_app
      statistics_filtered_by_version = statistics.select do |statistic|
        statistic.shortversion == version && statistic.version == build
      end
      statistics_filtered_by_version.first.crashes
    end

    def crash_groups(version, show_only_unresolved)
      reasons = version.crash_reasons('sort' => 'number_of_crashes', 'order' => 'desc')
      unresolved_reasons = show_only_unresolved ? unresolved_reasons(reasons) : reasons
      unresolved_reasons.map do |reason|
        Crash.new(file_line: "#{reason.file}:#{reason.line}",
                  occurrences: reason.number_of_crashes,
                  reason: reason.reason,
                  crash_class: reason.crash_class)
      end
    end

    def version(version:, build:)
      filtered_versions = filtered_versions_by_version_and_build(@hockeyapp_app.versions, version, build)

      raise "No version was found for #{version})#{build})" unless filtered_versions.count > 0

      filtered_versions.first
    end

    def unresolved_reasons(reasons)
      reasons.select do |reason|
        reason.fixed == false
      end
    end

    def hockeyapp(bundle_identifier, client)
      all_apps = client.get_apps
      apps = all_apps.select do |a|
        a.bundle_identifier == bundle_identifier
      end

      apps.first
    end

    def filtered_versions_by_version_and_build(versions, version_filter, build_filter)
      filtered_versions = versions.select do |version|
        version.shortversion == version_filter && version.version == build_filter
      end

      filtered_versions
    end
  end
end
