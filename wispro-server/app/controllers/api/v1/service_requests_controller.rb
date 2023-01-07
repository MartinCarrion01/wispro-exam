class Api::V1::ServiceRequestsController < ApplicationController
    include ValidateStatusParams

    before_action :authenticate_client, only: %i[create rejected_last_month]
    before_action :set_plan, only: %i[create]
    before_action :has_a_pending_request_to_given_provider?, only: %i[create]
    before_action :has_an_active_plan_with_given_provider?, only: %i[create]
    before_action :authenticate_provider, only: %i[update_status]
    before_action :validate_status_params, only: %i[update_status]
    before_action :set_service_request, only: %i[update_status]
    before_action :can_update_service_request?, only: %i[update_status]
    before_action :validate_service_request, only: %i[update_status]

    def create
        service_request = ServiceRequest.new(plan: @plan, client: @current_client)
        if service_request.save
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
        rejected_requests = @current_client.rejected_requests_last_month
        render(json: {service_requests: rejected_requests}, status: :ok)
    end

    private
    def set_plan
        @plan = Plan.find_by(id: params[:plan_id])
        if @plan.nil?
            render(json: {message: "El plan solicitado no existe"}, status: :not_found)
            false
        end
    end

    def has_a_pending_request_to_given_provider?
        if @current_client.has_a_pending_request_to_given_provider?(@plan.provider_id)
            render(json: {message: "Usted ya posee otra solicitud de contratación pendiente de revision con este proveedor"},
                 status: :bad_request)
            false
        end
    end

    def has_an_active_plan_with_given_provider?
        if @current_client.has_an_active_plan_with_given_provider?(@plan.provider_id)
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

    def can_update_service_request?
        if !@current_provider.can_update_service_request?(@service_request)
            render(json: {message: "No puede revisar una solicitud de contratación de un plan que no le pertence al proveedor actual"},
                 status: :bad_request)
            false
        end
    end

    def validate_service_request
        if @service_request.status != "pending"
            render(json: {message: "La solicitud de contrato requerida no es valida para su revisión"},
                 status: :bad_request)
            false
        end
    end
end
