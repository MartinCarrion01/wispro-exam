module Authenticable
    extend ActiveSupport::Concern

    included do
        def authenticate_user
            token = retrieve_token(request)
            begin
                decoded = jwt_decode(token)
                @current_user = User.find(decoded[:user_id])
            rescue ActiveRecord::RecordNotFound => exception
                render json: { message: "No se pudo encontrar un usuario usando el token de autorizacion" }, status: :unauthorized
            rescue JWT::DecodeError => exception
                render json: { message: exception.message }, status: :unauthorized
            end
        end
    end

    
    private
    def retrieve_token(request)
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        token
    end
end