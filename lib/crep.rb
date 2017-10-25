require "crep/version"
require 'crep/command'
require 'claide'
require 'logger'

module Crep

  $logger = Logger.new(STDOUT)
  $logger.level = Logger::DEBUG

  def self.run

    Command.run(ARGV)
  end
end
