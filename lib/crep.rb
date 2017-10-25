require "crep/version"
require 'crep/command'
require 'claide'

module Crep
  def self.run
    Command.run(ARGV)
  end
end
