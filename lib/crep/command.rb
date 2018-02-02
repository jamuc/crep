require 'claide'
require 'crep/version'

module Crep
  class Command < CLAide::Command
    require 'crep/command/crashes'
    require 'crep/command/apps'

    self.abstract_command = true
    self.command = 'crep'
    self.version = Crep::VERSION
    self.description = <<-DESC
      Crep is a crash reporter
    DESC
  end
end
