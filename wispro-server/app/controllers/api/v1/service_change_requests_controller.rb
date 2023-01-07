class Api::V1::ServiceChangeRequestsController < ApplicationController
    include ValidateStatusParams

    before_action :authenticate_client, only: %i[create]
    before_action :set_client_plan, only: %i[create]
    before_action :has_a_pending_change_request_to_given_provider, only: %i[create]
    before_action :set_new_plan, only: %i[create]
    before_action :does_new_plan_belong_to_same_provider?, only: %i[create]
    before_action :authenticate_provider, only: %i[update_status]
    before_action :validate_status_params, only: %i[update_status]
    before_action :set_service_change_request, only: %i[update_status]
    before_action :can_update_service_change_request?, only: %i[update_status]
    before_action :validate_service_change_request, only: %i[update_status]
    
    def create
        service_change_request = ServiceChangeRequest.new(current_plan: @client_plan, new_plan: @new_plan)
        if service_change_request.save
            render(json: {service_change_request: service_change_request}, status: :created)
        else
            render_errors_response(service_change_request)
        end
    end

    def update_status
        begin
            @service_change_request.update_status(params[:status])
            render(json: {service_change_request: @service_change_request}, status: :ok)
        rescue ActiveRecord::Record_Invalid => invalid
            render(json: {message: invalid.record.errors}, status: :bad_request)
        end
    end

    private
    def set_client_plan
        @client_plan = ClientPlan.find_by(plan_id: params[:current_plan_id], client_id: @current_client.id, active: true)
        if @client_plan.nil?
            render(json: {message: "No posee una suscripcion activa al plan que desea cambiar"},
                 status: :not_found)
            false
        end
    end

    def has_a_pending_change_request_to_given_provider?
        if @current_client.has_a_pending_change_request_to_given_provider(@client_plan.plan.provider_id)?
            render(json: {message: "Usted ya posee una solicitud de cambio pendiente de revision con el proveedor requerido"},
                 status: :bad_request)
            false
        end
    end

    def set_new_plan
        @new_plan = Plan.find_by(id: params[:new_plan_id])
        if @new_plan.nil?
            render(json: {message: "No existe el plan al cual desea cambiarse"},
                 status: :not_found)
            false
        end
    end

    def does_new_plan_belong_to_same_provider?
        if !@client_plan.plan.does_belong_to_the_same_provider_as?(@new_plan)
            render(json: {message: "El plan al cual desea cambiarse no es del mismo proveedor de su plan actual"},
                 status: :bad_request)
            false
        end
    end

    def set_service_change_request
        @service_change_request = ServiceChangeRequest.find_by(id: params[:id])
        if @service_change_request.nil? 
            render(json: {message: "La solicitud de cambio de plan requerida no existe"},
                 status: :not_found)
            false
        end
    end

    def can_update_service_change_request?
        if !@current_provider.can_update_service_change_request?(@service_change_request)
            render(json: {message: "No puede revisar una solicitud de cambio de un plan que no le pertence al proveedor actual"},
                 status: :bad_request)
            false
        end
    end

    def validate_service_change_request
        if @service_change_request.status != "pending"
            render(json: {message: "La solicitud de cambio de plan no es válida para su revisión"},
                 status: :bad_request)
            false
        end
    end
end
