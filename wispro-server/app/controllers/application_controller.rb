class ApplicationController < ActionController::API
    include JsonWebToken
    
    def authenticate_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            decoded = jwt_decode(header)
            @current_client = Client.find(decoded[:client_id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def render_errors_response(object)
        render(json: {message: object.errors}, status: :bad_request)
    end
end
