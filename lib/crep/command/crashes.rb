require 'crep/command'
require 'crep/crash_controller'
require 'crep/model/crash_sources/hockeyapp_crash_source'
require 'hockeyapp'

module Crep
  class Crashes < Command
    DEFAULT_TOP_COUNT = 5

    def self.options
      [
        ['--top=5', "If set, Crep will show the top x crashes. #{DEFAULT_TOP_COUNT} by default."],
        ['--identifier=<com.company.app>', 'Crep will show crashes for the app with this bundle identifier'],
        ['--version=<7.10.0>', 'The version of the App.'],
        ['--build=<24>', 'The Build number of the App.'],
        ['--only-unresolved', 'If set, resolved crashes will be filtered out.']
      ].concat(super)
    end

    self.summary = <<-DESC
      Shows a list of crashes
    DESC

    self.description = <<-DESC
      Besides the optional `top` parameter, Crep requires all other parameters.
    DESC

    def initialize(argv)
      @show_only_unresolved = argv.flag?('only-unresolved', false)
      @top = argv.option('top') || DEFAULT_TOP_COUNT
      @bundle_identifier = argv.option('identifier') || raise('Missing `identifier` parameter')
      @version = argv.option('version') || raise('Missing `version` parameter')
      @build = argv.option('build') || raise('Missing `build` parameter')
      super
    end

    def run
      crash_datasource = HockeyAppCrashSource.new
      crash_controller = CrashController.new(@bundle_identifier, @top, crash_datasource, @show_only_unresolved)
      crash_controller.top_crashes(@version, @build)
    end
  end
end
