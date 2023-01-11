class ApplicationController < ActionController::API
    #Incluye concern para crear tokens JWT y decodificarlos
    include JsonWebToken
    #Incluye concern para autenticar clientes y proveedores
    include Authenticable

    #Manejo de errores que surgen en la aplicación
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found_error
    
    private
    def handle_record_not_found_error(error)
        render(json: {message: error.message}, status: :not_found)
    end

    def handle_record_invalid_error(error)
        render(json: {message: error.record.errors}, status: :bad_request)
    end

    def handle_standard_error(error)
        render(json: {message: error.message}, status: :bad_request)
    end
end
