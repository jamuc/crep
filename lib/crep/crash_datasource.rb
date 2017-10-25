
module Crep

  class CrashDataSource

    def crashes (top)
      puts "fetching top #{top} crashes.."

      HockeyApp::Config.configure do |config|
        config.token = ENV["CREP_HOCKEY_API_TOKEN"]
      end

      client = HockeyApp.build_client

      apps = client.get_apps

      puts apps
    end

  end

end
