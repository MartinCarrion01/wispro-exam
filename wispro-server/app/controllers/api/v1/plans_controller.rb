class Api::V1::PlansController < ApplicationController    
    before_action :authorize_provider_admin, only: %i[create]

    def create
        plan = provider.plans.create!(plan_params)
        render(json: {plan: plan}, status: :created)
    end

    private
    def plan_params
        params.require(:plan).permit(:description)
    end

    def provider
        @current_user.provider
    end
end
