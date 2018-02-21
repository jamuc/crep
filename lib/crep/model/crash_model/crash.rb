module Crep
  class Crash
    attr_reader :file_line, :occurrences, :reason, :crash_class, :registered_at, :deep_link, :url

    def initialize(file_line:, occurrences:, reason:, crash_class:, registered_at:, deep_link:, url:)
      @file_line = file_line
      @occurrences = occurrences
      @reason = reason
      @crash_class = crash_class
      @registered_at = registered_at
      @deep_link = deep_link
      @url = url
    end
  end
end
