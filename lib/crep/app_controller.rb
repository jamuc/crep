module Crep
    class AppController

        def initialize(app_source)
            @app_source = app_source
            @app_source.configure()
        end
        
        def apps
            CrepLogger.info("Reporting apps:")
            @app_source.apps().each do | app |
                report_app(app)
            end
        end

        def report_app(app)
            puts "\n\t\t" + app.title
            report_app_versions(app)
        end

        def report_app_versions(app)
            @app_source.versions(app, 5).map do | version |
                puts "\t\t" + version
            end
        end
    end    
end