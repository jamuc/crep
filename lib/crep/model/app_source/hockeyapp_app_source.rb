# frozen_string_literal: true

require 'crep/model/app_source/app_source'
require 'crep/model/crash_model/version'
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

    def versions(app_identifier)
      apps = @client.get_apps.select do |a|
        a.public_identifier == app_identifier
      end

      raise("Unable to find app with identifier: #{app_identifier}") unless apps.count > 0

      app = apps.first
      app.versions.map do |version|
        Crep::Version.new(version.shortversion, version.version, app.public_identifier.downcase)
      end
    end
  end
end
