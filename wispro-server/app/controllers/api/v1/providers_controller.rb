class Api::V1::ProvidersController < ApplicationController
    include SetProvider

    before_action :set_provider, only: %i[show update destroy]

    def index
        providers = Provider.all
        render(json: {providers: providers}, status: :ok)
    end

    def show
        render(json: {provider: @provider}, status: :ok)
    end

    def create
        provider = Provider.new(provider_params)
        if provider.save
            render(json: {provider: provider}, status: :created)
        else
            render(json: {message: provider.errors}, status: :unprocessable_entity)
        end
    end

    def update
        if @provider.update(provider_params)
            render(json: {provider: @provider}, status: :ok)
        else
            render(json: {message: @provider.errors}, status: :unprocessable_entity)
        end
    end

    def destroy
        if @provider.destroy
            render(status: :no_content)
        else
            render(json: {message: @provider.errors}, status: :bad_request)
        end
    end

    private

    def provider_params
        params.require(:provider).permit(:name)
    end
end
