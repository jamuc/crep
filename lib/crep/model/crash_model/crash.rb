module Crep

    class Crash

        attr_reader :file_line, :occurrences, :reason, :crash_class

        def initialize(file_line:, occurrences:, reason:, crash_class:)
            @file_line = file_line
            @occurrences = occurrences
            @reason = reason
            @crash_class = crash_class
        end
    end
end