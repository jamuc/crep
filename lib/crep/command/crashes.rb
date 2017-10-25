require 'crep/command'
require 'crep/crash_datasource'
require 'hockeyapp'

default_top_count = 5

module Crep

  class Crashes < Command

    require 'hockeyapp'

    def self.options
      [
        ['--top=5', "If set, Crashes will show the top x crashes. #{default_top_count} by default."]
      ].concat(super)
    end

    self.summary = <<-DESC
      Shows a list of crashes
    DESC

    self.description = <<-DESC
      Arguments are all optional.
    DESC

    def initialize(argv)
        @top = argv.option('top') || default_top_count
        super
    end

    def run
      crash_datasource = CrashDataSource.new
      crash_datasource.crashes(@top)
    end
  end
end
