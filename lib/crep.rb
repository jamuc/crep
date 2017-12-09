require 'crep/version'
require 'crep/command'
require 'claide'
require 'logger'

module Crep
  XINGLogger = Logger.new(STDOUT)
  XINGLogger.level = Logger::DEBUG

  def self.run
    Command.run(ARGV)
  end
end
