module ValidateStatusParams
    extend ActiveSupport::Concern

    included do
        def validate_status_params
            if params[:status] != "approved" || params[:status] != "rejected"
                render(json: {message: "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"}, status: :bad_request)
                false
            end
        end
    end
end