class ApplicationController < ActionController::API
    #Incluye concern para crear tokens JWT y decodificarlos
    include JsonWebToken

    #Manejo de errores que surgen en la aplicación
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found_error
    rescue_from JWT::DecodeError, with: :handle_jwt_decode_error
    
    #Metodos de autenticacion de clientes y proveedores
    #mediante el uso de JWT (Json Web Token)
    def authenticate_client
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_client = Client.find(decoded[:client_id])
        rescue ActiveRecord::RecordNotFound => exception
            render json: { message: "No se pudo encontrar un cliente usando el token de autorizacion" }, status: :unauthorized
        end
    end

    def authenticate_provider
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_provider = Provider.find(decoded[:provider_id])
        rescue ActiveRecord::RecordNotFound => exception
            render json: { message: "No se pudo encontrar un proveedor usando el token de autorizacion" }, status: :unauthorized
        end
    end

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

    def handle_jwt_decode_error(error)
        render json: { message: error.message }, status: :unauthorized
    end

    def retrieve_token(request)
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        token
    end
end
