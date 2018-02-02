require 'crep/command'
require 'hockeyapp'

module Crep
    class Apps < Command
  
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
            CrepLogger.info("Running apps command.")
        end
    end
end