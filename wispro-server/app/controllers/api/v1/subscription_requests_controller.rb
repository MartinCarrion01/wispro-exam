class Api::V1::SubscriptionRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[create rejected_last_month]
    before_action :authenticate_provider, only: %i[update_status]

    def create
        begin
            subscription_request = SubscriptionRequest.create_subscription_request(params[:plan_id], @current_client)
            render(json: {subscription_request: subscription_request}, status: :created)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid => exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue SubscriptionRequest::PendingRequestToGivenProviderError,
             SubscriptionRequest::ActivePlanWithGivenProviderError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def update_status
        begin
            subscription_request = SubscriptionRequest.update_status(params[:id], params[:status], @current_provider)
            render(json: {subscription_request: subscription_request}, status: :ok)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid => exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue SubscriptionRequest::InvalidStatusParametersError,
             SubscriptionRequest::ProviderCantUpdateRequestError, 
             SubscriptionRequest::NotUpdatableRequestError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def rejected_last_month
        rejected_requests = @current_client.rejected_requests_last_month
        render(json: {subscription_requests: rejected_requests}, status: :ok)
    end
end