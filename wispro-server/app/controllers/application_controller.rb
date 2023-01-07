class ApplicationController < ActionController::API
    include JsonWebToken
    
    def authenticate_client
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_client = Client.find(decoded[:client_id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def authenticate_provider
        token = retrieve_token(request)
        begin
            decoded = jwt_decode(token)
            @current_provider = Provider.find(decoded[:provider_id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def render_errors_response(object)
        render(json: {message: object.errors}, status: :bad_request)
    end

    private
    def retrieve_token(request)
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        token
    end
end
