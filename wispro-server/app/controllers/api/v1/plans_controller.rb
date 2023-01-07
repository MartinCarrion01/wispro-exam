class Api::V1::PlansController < ApplicationController    
    before_action :set_provider, only: %i[create]

    def index
        if params[:id].present?
            set_provider
            render(json: {plans: @provider.plans}, status: :ok)
        else
            plans = Plan.all
            render(json: {plans: plans}, status: :ok)
        end
    end

    def create
        plan = @provider.plans.build(plan_params)
        if @provider.save
            render(json: {plan: plan}, status: :created)
        else
            render_errors_response(@provider)
        end
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end

    def set_provider
        @provider = Provider.find_by(id: params[:id])
        if @provider.nil?
            render(json: {message: "El proveedor solicitado no existe"}, status: :not_found)
        end
    end
end
