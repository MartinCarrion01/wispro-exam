class Api::V1::PlansController < ApplicationController    
    before_action :authenticate_provider, only: %i[create]

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
