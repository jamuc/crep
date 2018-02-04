# frozen_string_literal: true

require 'crep/command'
require 'crep/app_controller'
require 'crep/model/app_source/hockeyapp_app_source'

module Crep
  class Apps < Command
    # options should accept app name and version filter
    DEFAULT_VERSIONS_LIMIT = 5

    def self.options
      [
        ['--identifier=<com.company.app>', 'Crep will show app information with this identifier.'],
        ['--version=<7.10.0>', 'An optional filter for the version of an app.'],
        ['--build=<24>', 'An optional filter for the build of an app.'],
        ['--versions=5', "If set, Crep will limit the number of displayed versions per app. #{DEFAULT_VERSIONS_LIMIT} by default."]
      ].concat(super)
    end

    self.summary = <<-DESC
          Shows the apps with their versions.
      DESC

    self.description = <<-DESC
        Display apps with their versions.
      DESC

    def initialize(argv)
      super

      @versions_limit = argv.option('versions') || DEFAULT_VERSIONS_LIMIT
      CrepLogger.info("Versions will be limited to #{@versions_limit} per app")

      @identifier = argv.option('identifier')
      CrepLogger.info("Apps will be filtered by identifier: #{@identifier}") if @identifier

      @version = argv.option('version')
      CrepLogger.info("Version will be filtered: #{@version}") if @version

      @build = argv.option('build')
      CrepLogger.info("Build will be filtered: #{@build}") if @build
    end

    def run
      CrepLogger.info('Reporting apps:')

      app_source = HockeyAppAppSource.new
      app_controller = AppController.new(app_source, @identifier, @version, @build, @versions_limit.to_i)
      app_controller.apps
    end
  end
end