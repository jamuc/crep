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
      @client.get_apps.map do |app|
        app
      end
    end

    def versions(app, limit)
      app.versions.first(limit).map do | version |
        "#{version.shortversion} (#{version.version})"
      end
    end
  end
end
