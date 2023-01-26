class Api::V1::Admin::PlansController < Api::V1::Admin::BaseController    
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