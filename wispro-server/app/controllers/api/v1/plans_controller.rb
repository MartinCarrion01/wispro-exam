class Api::V1::PlansController < ApplicationController    
    before_action :authenticate_provider, only: %i[create]

    def index
        begin
            if params[:provider_id].present?
                plans = Plan.list_by_provider(params[:provider_id])
                render(json: {plans: plans}, status: :ok)
            else
                plans = Plan.all
                render(json: {plans: plans}, status: :ok)
            end
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        end
    end

    def create
        plan = @current_provider.plans.build(plan_params)
        if @current_provider.save
            render(json: {plan: plan}, status: :created)
        else
            render(json: {message: @current_provider.errors}, status: :bad_request)
        end
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end
end
