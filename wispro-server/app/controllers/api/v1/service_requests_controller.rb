class Api::V1::ServiceRequestsController < ApplicationController
    include SetPlan

    before_action :authenticate_request, only: %i[create rejected]
    before_action :set_plan, only: %i[create]
    before_action :validate_status_params, only: %i[update_status]
    before_action :set_service_request, only: %i[update_status]
    before_action :validate_service_request, only: %i[update_status]

    def create
        service_request = ServiceRequest.find_or_initialize_by(plan_id: @plan.id, client_id: @current_client.id, status: :pending)
        if service_request.persisted?
            render(json: {message: "Ya tiene una solicitud de contrato existente pendiente de revisión para el plan solicitado"}, status: :bad_request)
        elsif service_request.save
            render(json: {service_request: service_request},status: :ok)
        else
            render_errors_response(service_request)
        end
    end

    def update_status
        @service_request.status = params[:status]
        if @service_request.save
            if params[:status] == "approved"
                render(json: {message: "La solicitud de contrato ha sido aceptada correctamente"}, status: :ok)
            elsif params[:status] == "rejected"
                render(json: {message: "La solicitud de contrato ha sido rechazada correctamente"}, status: :ok)
            end
        else
            render_errors_response(@service_request)
        end
    end

    def rejected
        rejected_requests = ServiceRequest.rejected_last_month(@current_client.id)
        render(json: {service_requests: rejected_requests}, status: :ok)
    end

    private
    def set_service_request
        @service_request = ServiceRequest.find_by(id: params[:id])
        if @service_request.nil?
            render(json: {message: "La solicitud de contrato requerida no existe"}, status: :not_found)
            false
        end
    end

    def validate_service_request
        if @service_request.status != "pending"
            render(json: {message: "La solicitud de contrato requerida no es valida para su aprobación/rechazo"}, status: :bad_request)
            false
        end
    end
end