require 'crep/model/crash_sources/crash_source'
require 'crep/model/crash_model/app'
require 'crep/model/crash_model/crash'
require 'crep/logger'
require 'hockeyapp'

module Crep
  # The HockeyApp Crash Source
  class HockeyAppCrashSource < CrashSource
    def configure(bundle_identifier)
      HockeyApp::Config.configure do |config|
        raise 'Missing API token (CREP_HOCKEY_API_TOKEN)' unless ENV['CREP_HOCKEY_API_TOKEN']
        config.token = ENV['CREP_HOCKEY_API_TOKEN']
      end

      @client = HockeyApp.build_client
      @hockeyapp_app = hockeyapp(bundle_identifier, @client)
      CrepLogger.error("No app with the give bundle identifier (#{bundle_identifier}) was found.") unless @hockeyapp_app
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
        url = url(app_id: reason.app.public_identifier, version_id: version.id, reason_id: reason.id)
        Crash.new(file_line: "#{reason.file}:#{reason.line}",
                  occurrences: reason.number_of_crashes,
                  reason: reason.reason,
                  crash_class: reason.crash_class,
                  registered_at: Date.parse(reason.created_at),
                  url: url)
      end
    end

    def url(app_id:, version_id:, reason_id:)
      "https://rink.hockeyapp.net/manage/apps/#{app_id}/app_versions/#{version_id}/crash_reasons/#{reason_id}"
    end

    def version(version:, build:)
      filtered_versions = filtered_versions_by_version_and_build(@hockeyapp_app.versions, version, build)

      raise "No version was found for #{version})#{build})".red unless filtered_versions.count > 0

      report_version = filtered_versions.first

      CrepLogger.warn("Multiple results for #{version}/#{build} were found, using the first (with ID #{report_version.id}) one that was found") unless filtered_versions.count <= 1

      report_version
    end

    def unresolved_reasons(reasons)
      reasons.reject(&:fixed)
    end

    def hockeyapp(bundle_identifier, client)
      all_apps = client.get_apps
      apps = all_apps.select do |app|
        app.bundle_identifier == bundle_identifier
      end
      apps.first
    end

    def filtered_versions_by_version_and_build(versions, version_filter, build_filter)
      versions.select do |version|
        (version.shortversion == version_filter) && (version.version == build_filter)
      end
    end
  end
end
