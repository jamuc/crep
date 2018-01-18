require 'logger'

module Crep
  CrepLogger = Logger.new(STDOUT)
  CrepLogger.level = Logger::DEBUG
  CrepLogger.datetime_format = '%Y-%m-%d %H:%M:%S'
  CrepLogger.formatter = proc do |severity, datetime, progname, msg|
    case severity
        when "DEBUG"
          "\e[DEBUG] #{datetime}: #{msg}\n".light_magenta
        when "ERROR"
          "[ERROR] #{datetime}: #{msg}\n".red
        when "FATAL"
          "[FATAL] #{datetime}: #{msg}\n".red
        when "INFO"
          "[INFO] #{datetime}: #{msg}\n".green
        when "WARN"
          "[WARNING] #{datetime}: #{msg}\n".yellow
        else
          "[LOG] #{datetime}: #{msg}\n".blue
        end
  end
end
