class Api::V1::SubscriptionChangeRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[create]
    before_action :authenticate_provider, only: %i[update_status]
    
    def create
        begin
            subscription_change_request = SubscriptionChangeRequest.create_subscription_change_request(params[:current_subscription_id], params[:new_plan_id], @current_client)
            render(json: {subscription_change_request: subscription_change_request}, status: :created)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid=> exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue SubscriptionChangeRequest::PendingChangeRequestToGivenProviderError,
             SubscriptionChangeRequest::NewPlanIsFromOtherProviderError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def update_status
        begin
            subscription_change_request = SubscriptionChangeRequest.update_status(params[:id], params[:status], @current_provider)
            render(json: {subscription_change_request: subscription_change_request}, status: :ok)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid=> exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue SubscriptionChangeRequest::InvalidStatusParametersError,
             SubscriptionChangeRequest::ProviderCantUpdateChangeRequestError, 
             SubscriptionChangeRequest::NotUpdatableChangeRequestError=> exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end
end
