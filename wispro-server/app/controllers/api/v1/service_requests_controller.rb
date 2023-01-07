class Api::V1::ServiceRequestsController < ApplicationController
    include SetPlan
    include ValidateStatusParams

    before_action :authenticate_request, only: %i[create rejected_last_month]
    before_action :set_plan, only: %i[create]
    before_action :has_an_active_plan_with_given_provider?, only: %i[create]
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
        begin
            @service_request.update_status(params[:status])
            render(json: {service_request: @service_request}, status: :ok)
        rescue ActiveRecord::Record_Invalid => invalid
            render(json: {message: invalid.record.errors}, status: :bad_request)
        end
    end

    def rejected_last_month
        rejected_requests = ServiceRequest.rejected_last_month(@current_client.id)
        render(json: {service_requests: rejected_requests}, status: :ok)
    end

    private
    def has_an_active_plan_with_given_provider?
        if ClientPlan.has_an_active_plan_with_given_provider?(@current_client.id, @plan.provider_id)
            render(json: {message: "Usted ya posee una suscripcion activa a un plan de este proveedor, si desea cambiar su plan, cree una solicitud de cambio de plan"},
                 status: :bad_request)
            false
        end
    end

    def set_service_request
        @service_request = ServiceRequest.find_by(id: params[:id])
        if @service_request.nil?
            render(json: {message: "La solicitud de contrato requerida no existe"},
                 status: :not_found)
            false
        end
    end

    def validate_service_request
        if @service_request.status != "pending"
            render(json: {message: "La solicitud de contrato requerida no es valida para su aprobación/rechazo"},
                 status: :bad_request)
            false
        end
    end
end
