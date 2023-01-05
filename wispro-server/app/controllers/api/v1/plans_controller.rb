class Api::V1::PlansController < ApplicationController
    include SetProvider
    
    before_action :authenticate_request, only: %i[require]
    before_action :set_provider, only: %i[create update destroy require]
    before_action :set_plan, only: %i[update destroy require]

    def index
        plans = Plan.index
    end

    def create
        plan = @provider.plans.build(plan_params)
        if @provider.save
            render(json: {plan: plan}, status: :created)
        else
            render_errors_response(@provider)
        end
    end

    def update
        if @plan.update(plan_params)
            render(json: {plan: @plan}, status: :ok)
        else
            render_errors_response(@plan)
        end
    end

    def destroy
        if @plan.destroy
            render(status: :no_content)
        else
            render_errors_response(@plan)
        end
    end

    def require
        service_request = ServiceRequest.find_or_initialize_by(plan_id: @plan.id, client_id: @current_client.id)
        if service_request.persisted?
            render(json: {message: "Ya tiene una o mas solicitudes de contratación existentes, 
                                    si desea cambiar su plan, realice una solicitud de cambio"}, status: :bad_request)
        elsif service_request.save
            render(json: {message: "Su solicitud de contratacion del plan requerido 
                                    ha sido creada exitosamente, aguarde respuesta del proveedor"}, status: :ok)
        else
            render(json: {message: service_request.errors}, status: :unprocessable_entity)
        end
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end

    def set_plan
        @plan = @provider.plans.where(id: params[:plan_id]).first
        if @plan.nil?
            render(json: {message: "El plan solicitado no existe"}, status: :not_found)
            false
        end
    end
end
