class Api::V1::SubscriptionChangeRequestsController < ApplicationController
    before_action :authorize_client, only: %i[index]
    before_action :authorize_provider_admin, only: %i[update]
    
    def create
        subscription = Subscription.find_by(id: params[:current_subscription_id], client_id: client.id, active: true)
        if subscription.nil?
            raise ActiveRecord::RecordNotFound.new("No posee una suscripcion activa al plan que desea cambiar")
        end

        new_plan = Plan.find_by(id: new_plan_id)
        if new_plan.nil?
            raise ActiveRecord::RecordNotFound.new("No existe el plan al cual desea cambiarse")
        end

        subscription_change_request = SubscriptionChangeRequest.create!(current_subscription: subscription, new_plan: new_plan)
        render(json: {subscription_change_request: subscription_change_request}, status: :created)
    end

    def update
        subscription_change_request = SubscriptionChangeRequest.find_by(id: params[:id])
        if subscription_change_request.nil? 
            raise ActiveRecord::RecordNotFound.new("La solicitud de cambio de plan requerida no existe")
        end

        unless provider.owns_the_plan_stated_in_this_subscription_change_request?(subscription_change_request)
            raise ProviderAccessForbiddenError.new "No puede revisar una solicitud de cambio de un plan que no le pertenece"
        end

        subscription_change_request.update!(status: params[:status])
        render(json: {subscription_change_request: subscription_change_request}, status: :ok)
    end

    private
    class ProviderAccessForbiddenError < StandardError; end 

    def client
        @current_user.client
    end

    def provider
        @current_user.provider
    end
end
