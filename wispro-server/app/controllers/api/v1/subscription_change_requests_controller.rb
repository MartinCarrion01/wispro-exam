class Api::V1::SubscriptionChangeRequestsController < ApplicationController
    before_action :authorize_client, only: %i[index]
    
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

    private
    def client
        @current_user.client
    end
end
