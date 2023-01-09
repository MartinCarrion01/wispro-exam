class Api::V1::ProvidersController < ApplicationController
    def create
        provider = Provider.new(provider_params)
        if provider.save
            render(json: {provider: provider}, status: :created)
        else
            render(json: {message: provider.errors}, status: :bad_request)
        end
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

    private
    def provider_params
        params.require(:provider).permit(:name)
    end
end
