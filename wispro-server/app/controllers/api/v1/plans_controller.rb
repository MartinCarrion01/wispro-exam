class Api::V1::PlansController < ApplicationController    
    before_action :set_provider, if: -> { params[:provider_id].present? }, only: %i[create]
    before_action :authenticate_provider, only: %i[create]

    def index
        if @provider.present?
            render(json: {plans: @provider.plans}, status: :ok)
        else
            plans = Plan.all
            render(json: {plans: plans}, status: :ok)
        end
    end

    def create
        plan = @current_provider.plans.build(plan_params)
        if @current_provider.save
            render(json: {plan: plan}, status: :created)
        else
            render_errors_response(@current_provider)
        end
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end

    def set_provider
        @provider = Provider.find_by(id: params[:provider_id])
        if @provider.nil?
            render(json: {message: "El proveedor solicitado no existe"}, status: :not_found)
            false
        end
    end
end
