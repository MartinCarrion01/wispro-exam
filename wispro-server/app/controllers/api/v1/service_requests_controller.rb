class Api::V1::ServiceRequestsController < ApplicationController
    include SetPlan

    def create
        service_request = ServiceRequest.find_or_initialize_by(plan_id: @plan.id, client_id: @current_client.id)
        if service_request.persisted?
            render(json: {message: "Ya tiene una solicitud existente para el plan solicitado"}, status: :bad_request)
        elsif service_request.save
            render(json: {service_request: service_request},status: :ok)
        else
            render_errors_response(service_request)
        end
    end

    def update
        if @service_request.update(update_service_request_params)
            render(json: {service_request: @service_request}, status: :ok)
        else
            render_errors_response(@service_request)
        end
    end

    private
    def update_service_request_params
        params.require(:service_request).permit(:status)
    end

    def service_request
        @service_request = ServiceRequest.find_by(id: params[:id])
        if @service_request.nil?
            render(json: {message: "La solicitud requerida no existe"}, status: :not_found)
            false
        end
    end
end
