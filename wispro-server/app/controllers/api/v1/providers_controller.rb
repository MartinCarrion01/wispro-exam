class Api::V1::ProvidersController < ApplicationController
    skip_before_action :authenticate_user, only: %i[get_plans]

    def get_plans
        providers = Provider.includes(:plans)

        formatted_providers = providers.as_json(only: [:id, :name],
                                                include: {plans: {only: [:id, :description]}})

        render(json: {providers: formatted_providers}, status: :ok)
    end
end
