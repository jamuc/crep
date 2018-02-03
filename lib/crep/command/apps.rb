require 'crep/command'
require 'crep/app_controller'
require 'crep/model/app_source/hockeyapp_app_source'

module Crep
  class Apps < Command
    # options should accept app name and version filter
    DEFAULT_VERSIONS_LIMIT = 5

    def self.options
      [
        ['--identifier=<com.company.app>', 'Crep will show app information with this identifier'],
        ['--version=<7.10.0>', 'An optional filter for the version of an app.'],
        ['--build=<24>', 'An optional filter for the build of an App.'],
        ['--versions=5', "If set, Crep will limit the number of displayed versions per app. #{DEFAULT_VERSIONS_LIMIT} by default."]
      ].concat(super)
    end

    self.summary = <<-DESC
          Shows the apps with their versions available for the current API token
      DESC

    self.description = <<-DESC
        Shows apps with their versions. The CREP_HOCKEY_API_TOKEN needs to be set.
      DESC

    def initialize(argv)
      super

      @versions_limit = argv.option('versions').to_i || DEFAULT_VERSIONS_LIMIT
      @identifier = argv.option('identifier')
      CrepLogger.info("Identifier is #{ @identifier }") unless !@identifier
      @version = argv.option('version')
      @build = argv.option('build')
    end

    def run
      CrepLogger.info("Reporting apps:")

      app_source = HockeyAppAppSource.new
      app_controller = AppController.new(app_source, @identifier, @version, @build, @versions_limit)
      app_controller.apps
    end
  end
end
