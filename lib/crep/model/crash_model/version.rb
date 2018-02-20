module Crep
  class Version
    attr_reader :version, :build, :app_identifier

    def initialize(version, build, app_identifier)
      @version = version
      @build = build 
      @app_identifier = app_identifier
    end
  end
end
