require 'crep/command'
require 'crep/crash_datasource'
require 'hockeyapp'

default_top_count = 5

module Crep

  class Crashes < Command

    require 'hockeyapp'

    def self.options
      [
        ['--top=5', "If set, Crep will show the top x crashes. #{default_top_count} by default."],
        ['--app=<my app title>', "Crep will show crashes of this app"]
      ].concat(super)
    end

    self.summary = <<-DESC
      Shows a list of crashes
    DESC

    self.description = <<-DESC
      Besides the optional `top` parameter, Crep requires the `app` parameter.
    DESC

    def initialize(argv)
        @top = argv.option('top') || default_top_count
        raise 'Missing `app` parameter' unless @app_title = argv.option('app')
        super
    end

    def run
      crash_datasource = CrashDataSource.new
      crash_datasource.crashes(@top, @app_title)
    end
  end
end
