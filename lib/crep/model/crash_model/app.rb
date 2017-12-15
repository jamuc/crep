module Crep
  # App represents an App
  class App
    attr_reader :name, :bundle_identifier

    def initialize(name, bundle_identifier)
      @name = name
      @bundle_identifier = bundle_identifier
    end
  end
end
