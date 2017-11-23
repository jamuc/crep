module Crep

    class Crash

        attr_reader :file_line, :occurrences, :reason, :crash_class, :registered_at, :url

        def initialize(file_line:, occurrences:, reason:, crash_class:, registered_at:, url:)
            @file_line = file_line
            @occurrences = occurrences
            @reason = reason
            @crash_class = crash_class
            @registered_at = registered_at
            @url = url
        end
    end
end