class ApplicationController < ActionController::API
    include JsonWebToken
    
    def authenticate_client
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_client = Client.find(decoded[:client_id])
        rescue ActiveRecord::RecordNotFound => exception
            render json: { message: "No se pudo encontrar un cliente usando el token de autorizacion" }, status: :unauthorized
        rescue JWT::DecodeError => exception
            render json: { message: exception.message }, status: :unauthorized
        end
    end

    def authenticate_provider
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_provider = Provider.find(decoded[:provider_id])
        rescue ActiveRecord::RecordNotFound => exception
            render json: { message: "No se pudo encontrar un proveedor usando el token de autorizacion" }, status: :unauthorized
        rescue JWT::DecodeError => exception
            render json: { message: exception.message }, status: :unauthorized
        end
    end

    private
    def retrieve_token(request)
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        token
    end
end
