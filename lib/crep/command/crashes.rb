require 'crep/command'
require 'crep/crash_controller'
require 'crep/model/crash_sources/hockeyapp_crash_source'
require 'hockeyapp'

module Crep
  class Crashes < Command
    @default_top_count = 5

    def self.options
      [
        ['--top=5', "If set, Crep will show the top x crashes. #{default_top_count} by default."],
        ['--identifier=<com.company.app>', 'Crep will show crashes for the app with this bundle identifier'],
        ['--version=<7.10.0>', 'The version of the App.'],
        ['--build=<24>', 'The Build number of the App.']
      ].concat(super)
    end

    self.summary = <<-DESC
      Shows a list of crashes
    DESC

    self.description = <<-DESC
      Besides the optional `top` parameter, Crep requires all other parameters.
    DESC

    def initialize(argv)
      @top = argv.option('top') || Crashes.default_top_count
      raise 'Missing `identifier` parameter' unless @bundle_identifier = argv.option('identifier')
      raise 'Missing `version` parameter' unless @version = argv.option('version')
      raise 'Missing `build` parameter' unless @build = argv.option('build')
      super
    end

    def run
      crash_datasource = HockeyAppCrashSource.new
      crash_controller = CrashController.new(@bundle_identifier, @top, crash_datasource)
      crash_controller.top_crashes(@version, @build)
    end
  end
end
