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
            puts app
        end
    end    
end