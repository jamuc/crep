# frozen_string_literal: true

module Crep
  class AppController
    def initialize(app_source, identifier, version, build, versions_limit)
      @identifier = identifier&.downcase
      @version = version
      @build = build
      @versions_limit = versions_limit

      @app_source = app_source
      @app_source.configure
    end

    def apps
      filtered_apps = @app_source.apps.select do |app|
        @identifier ? app.bundle_identifier.downcase == @identifier : true
      end
      filtered_apps.each do |app|
        report_app(app.public_identifier, app.title)
      end
    end

    def report_app(identifier, title)
      puts "\n\t\t" + title
      report_app_versions(identifier)
    end

    def report_app_versions(app_identifier)

      versions = @app_source.versions(app_identifier)

      filtered_versions = versions.select do |v|
        version_match = @version ? v.version == @version : true
        build_match = @build ? v.build == @build : true
        version_match && build_match
      end

      out = filtered_versions.first(@versions_limit).map do |v|
        "#{v.version} (#{v.build})"
      end
      out.map do |version|
        puts "\t\t" + version
      end
    end
  end
end
