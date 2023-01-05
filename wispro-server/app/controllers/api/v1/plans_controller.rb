class Api::V1::PlansController < ApplicationController
    include SetProvider
    
    before_action :set_provider, only: %i[create update destroy]
    before_action :set_plan, only: %i[update destroy]

    def index
        if params[:id].present?
            set_provider
            render(json: {plans: @provider.plans}, status: :ok)
        else
            plans = Plans.all
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
