class Api::V1::ProvidersController < ApplicationController
    def create
        provider = Provider.new(provider_params)
        if provider.save
            render(json: {provider: provider}, status: :created)
        else
            render_errors_response(provider)
        end
    end

    private
    def provider_params
        params.require(:provider).permit(:name)
    end
end
