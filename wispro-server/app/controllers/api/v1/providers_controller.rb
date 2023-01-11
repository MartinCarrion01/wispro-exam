class Api::V1::ProvidersController < ApplicationController
    def create
        provider = Provider.create!(provider_params)
        render(json: {provider: provider}, status: :created)
    end

    def get_token
        provider = Provider.find_by(id: params[:id])
        if provider.present?
            token = jwt_encode(provider_id: provider.id)
            render(json: {token: token}, status: :ok)
        else
            render(json: {message: "El proveedor solicitado no existe"}, status: :not_found)
        end
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
