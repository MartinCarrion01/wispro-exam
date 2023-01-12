class Api::V1::SubscriptionChangeRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[create]
    before_action :authenticate_provider, only: %i[update_status]
    
    def create
        created_subscription_change_request = SubscriptionChangeRequest
        .create_subscription_change_request(params[:current_plan_id],
                                            params[:new_plan_id],
                                            @current_client)
        
        render(json: {subscription_change_request: created_subscription_change_request}, status: :created)
    end

    def update_status
        updated_subscription_change_request = SubscriptionChangeRequest
        .update_status(params[:id], params[:status], @current_provider)
        
        render(json: {subscription_change_request: updated_subscription_change_request}, status: :ok)
    end
end
