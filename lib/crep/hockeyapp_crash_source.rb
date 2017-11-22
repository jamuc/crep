require 'crep/crash_source'

module Crep
  class HockeyAppCrashSource < CrashSource
    def configure
      HockeyApp::Config.configure do |config|
        raise 'Missing API token (CREP_HOCKEY_API_TOKEN)' unless token = ENV['CREP_HOCKEY_API_TOKEN']
        config.token = token
      end

      @client = HockeyApp.build_client
    end

    def crashes(top, app_title, version, build)
      app = app(app_title)

      $logger.debug("Fetching top #{top} crash groups for #{app_title} (#{version}/#{build}) #{app.public_identifier}")

      filtered_versions = filtered_versions_by_version_and_build(app.versions, version, build)

      version = filtered_versions.first

      show_version_info(version, top)
    end

    def show_version_info(version, top)
      reasons = version.crash_reasons ({ 'sort' => 'number_of_crashes', 'order' => 'desc' })
      unresolved_reasons = unresolved_reasons(reasons).take(top.to_i)
      unresolved_reasons.each do |reason|
        show_reason reason
      end
      end

    def unresolved_reasons(reasons)
      reasons.select do |reason|
        reason.fixed == false
      end
      end

    def show_reason(reason)
      $logger.debug("Number of crashes: #{reason.number_of_crashes}")
      $logger.debug("File/Line: #{reason.file}:#{reason.line}")
      end

    def app(title)
      $logger.debug("Configuring Hockey for #{title}")

      apps = @client.get_apps

      app = apps.select do |app|
        app.title == title
      end

      app.first
      end

    def filtered_versions_by_version_and_build(versions, version_filter, build_filter)
      filtered_versions = versions.select do |version|
        version.shortversion == version_filter && version.version == build_filter
      end

      filtered_versions
      end
  end
end
