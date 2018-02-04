# frozen_string_literal: true

require 'crep/model/app_source/app_source'
require 'hockeyapp'

module Crep
  class HockeyAppAppSource < AppSource
    def configure
      HockeyApp::Config.configure do |config|
        raise 'Missing API token (CREP_HOCKEY_API_TOKEN)' unless ENV['CREP_HOCKEY_API_TOKEN']
        config.token = ENV['CREP_HOCKEY_API_TOKEN']
      end

      @client = HockeyApp.build_client
    end

    def apps
      @client.get_apps
    end

    def versions(app, version, build, limit)
      filtered_versions = app.versions.select do |v|
        version_match = version ? v.shortversion == version : true
        build_match = build ? v.version == build : true
        version_match && build_match
      end

      filtered_versions.first(limit).map do |v|
        "#{v.shortversion} (#{v.version})"
      end
    end
  end
end
