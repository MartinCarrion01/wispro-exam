class ApplicationController < ActionController::API
    include JsonWebToken
    
    private
    def decode_header
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            decoded = jwt_decode(header)
            @current_client = Client.find(decoded[:client_id])
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end
end
