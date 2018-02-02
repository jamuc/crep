require 'crep/command'
require 'crep/app_controller'
require 'crep/model/app_source/hockeyapp_app_source'

module Crep
    class Apps < Command

        # options should accept app name and version filter
  
        self.summary = <<-DESC
            Shows the apps available for the current API token
        DESC

        self.description = <<-DESC
            The CREP_HOCKEY_API_TOKEN needs to be set.
        DESC

        def initialize(argv)
            super
        end

        def run
            app_source = HockeyAppAppSource.new
            app_controller = AppController.new(app_source)
            app_controller.apps()
        end
    end
end