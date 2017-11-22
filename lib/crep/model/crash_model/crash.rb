module Crep

    class Crash

        attr_reader :file_line, :occurrences

        def initialize(file_line, occurrences)
            @file_line = file_line
            @occurrences = occurrences
        end
        
    end
end