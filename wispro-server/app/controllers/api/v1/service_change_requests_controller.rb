class Api::V1::ServiceChangeRequestsController < ApplicationController
    before_action :authenticate_request, only: %i[:create]
    
    def create
        service_change_request = ServiceChangeRequest.new(service_change_request_params)
        if service_change_request.save
            render(json: {service_change_request: service_change_request}, status: :created)
        else
            render_errors_response(service_change_request)
        end
    end

    private
    def service_change_request_params
        params.require(:service_change_request).permit(:plan_id, :service_request_id)
    end
end
