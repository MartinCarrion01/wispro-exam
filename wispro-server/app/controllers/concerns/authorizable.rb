module Authorizable
    extend ActiveSupport::Concern

    included do
        class NotAuthorizedError < StandardError; end

        def authorize_client
            unless @current_user.client?
                raise NotAuthorizedError.new "No posee permisos de cliente para realizar esta acción" 
            end
        end

        def authorize_provider_admin
            unless @current_user.provider_admin?
                raise NotAuthorizedError.new "No posee permisos de administrador para realizar esta acción" 
            end
        end
    end
end