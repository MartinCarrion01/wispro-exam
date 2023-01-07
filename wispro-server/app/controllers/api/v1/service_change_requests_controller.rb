class Api::V1::ServiceChangeRequestsController < ApplicationController
    include ValidateStatusParams
    include SetPlan

    before_action :authenticate_request, only: %i[create]
    before_action :set_plan, only: %i[create]
    before_action :set_service_request, only: %i[create]
    before_action :validate_service_request, only: %i[create]
    before_action :validate_status_params, only: %i[update_status]
    
    def create
        service_change_request = ServiceChangeRequest.find_or_initialize_by(plan_id: @plan.id, service_request_id: @service_request.id, status: "pending")
        if service_change_request.persisted?
            render(json: {message: "Ya posee una solicitud de cambio de plan pendiente"}, status: :bad_request)
        elsif service_change_request.save
            render(json: {service_change_request: service_change_request}, status: :created)
        else
            render_errors_response(service_change_request)
        end
    end

    def update_status
        response_message = ""
        @service_change_request.status = params[:status]
        if params[:status] == "approved"
            @service_change_request.service_request.status = "inactive"
            new_service_request = ServiceRequest.new(plan: @service_change_request.plan, client: @service_change_request.service_request.client)
            if !new_service_request.valid?
                render(json: {message: new_service_request.errors})
            end
        elsif params[:status] == "rejected"
            response_message = "La solicitud de cambio de plan ha sido rechazada correctamente"
        end
    end

    private
    def set_service_request
        @service_request = ServiceRequest.find_by(id: params[:service_request_id])
        if @service_request.nil?
            render(json: {message: "La solicitud de contrato requerida no existe"}, status: :not_found)
        end
    end

    def validate_service_request
        if @service_request.client.id != @current_client.id
            render(json: {message: "La solicitud de contrato no le pertenece al cliente actual"}, status: :bad_request)
            false
        end
        if @service_request.status != "approved"
            render(json: {message: "La solicitud de contrato no es válida para realizar un cambio de plan"}, status: :bad_request)
            false
        end
    end
end
