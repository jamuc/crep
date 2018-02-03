module Crep
    class AppController

        def initialize(app_source, identifier, version, build, versions_limit)
          @identifier = identifier ? identifier.downcase : nil
            @version = version
            @build = build
            @versions_limit = versions_limit

            @app_source = app_source
            @app_source.configure()
        end
        
        def apps
          filtered_apps = @app_source.apps.select do | app |
            @identifier ? app.bundle_identifier.downcase == @identifier : true
          end
            filtered_apps.each do | app |
                report_app(app)
            end
        end

        def report_app(app)
            puts "\n\t\t" + app.title
            report_app_versions(app)
        end

        def report_app_versions(app)
            @app_source.versions(app, @version, @build, @versions_limit).map do | version |
                puts "\t\t" + version
            end
        end
    end    
end
