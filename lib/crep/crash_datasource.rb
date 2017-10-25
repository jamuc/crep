
module Crep

  class CrashDataSource

    def crashes (top, app_title)
      puts "fetching top #{top} crashes for #{app_title}"

      app = app(app_title)
      puts app.title
      puts app.public_identifier
      puts app.crash_reasons
    end

    def app(title)
      base_uri = ENV["CREP_HOCKEY_BASE_URI"]

      HockeyApp::Config.configure do |config|
        config.token = ENV["CREP_HOCKEY_API_TOKEN"]
        config.base_uri = base_uri
      end

      client = HockeyApp.build_client

      apps = client.get_apps
      app = apps.select do |app|
        app.title == title
      end

      app.first
    end
  end

end
