class Api::V1::PlansController < ApplicationController
    include SetProvider

    before_action :set_provider, only: %i[create update destroy]
    before_action :set_plan, only: %i[update destroy]

    def create
        plan = @provider.plans.build(plan_params)
        if @provider.save
            render(json: {plan: plan}, status: :created)
        else
            render(json: {message: @provider.errors}, status: :unprocessable_entity)
        end
    end

    def update
        if @plan.update(plan_params)
            render(json: {plan: @plan}, status: :ok)
        else
            render(json: {message: @plan.errors}, status: :unprocessable_entity)
        end
    end

    def destroy
        if @plan.destroy
            render(status: :no_content)
        else
            render(json: {message: @plan.errors}, status: :bad_request)
        end
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end

    def set_plan
        @plan = @provider.plans.where(id: params[:plan_id])
        if @plan.nil?
            render(json: {message: "El plan solicitado no existe"}, status: :not_found)
            false
        end
    end
end
