class ApplicationController < ActionController::API
    include JsonWebToken
    include Authenticable
    include Authorizable

    #Manejo de errores que surgen en la aplicación
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found_error

    before_action :authenticate_user
    
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
