class Api::V1::PlansController < ApplicationController    
    before_action :authenticate_provider, only: %i[create]

    def create
        plan = @current_provider.plans.create!(plan_params)
        
        render(json: {plan: plan}, status: :created)
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end
end
