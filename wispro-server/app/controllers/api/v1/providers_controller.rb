class Api::V1::ProvidersController < ApplicationController
    skip_before_action :authenticate_user, only: %i[get_plans]
    before_action :authorize_provider_admin, only: %i[create]

    def create
        provider = @current_user.create_provider!(provider_params)
        render(json: {provider: provider}, status: :created)
    end

    def get_plans
        providers = Provider.includes(:plans)
        formatted_providers = providers.as_json(only: [:id, :name],
                                                include: {plans: {only: [:id, :description]}})
        render(json: {providers: formatted_providers}, status: :ok)
    end
    
    private
    def provider_params
        params.require(:provider).permit(:name)
    end
end
