class Api::V1::ServiceRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[create rejected_last_month]
    before_action :authenticate_provider, only: %i[update_status]

    def create
        begin
            service_request = ServiceRequest.create_service_request(params[:plan_id], @current_client)
            render(json: {service_request: service_request},status: :ok)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid=> exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue ServiceRequest::PendingRequestToGivenProviderError,
             ServiceRequest::ActivePlanWithGivenProviderError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def update_status
        begin
            service_request = ServiceRequest.update_status(params[:id], params[:status], @current_provider)
            render(json: {service_request: @service_request}, status: :ok)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::Record_Invalid => invalid
            render(json: {message: invalid.record.errors}, status: :bad_request)
        rescue ServiceRequest::InvalidStatusParametersError,
             ServiceRequest::ProviderCantUpdateRequestError, 
             ServiceRequest::NotUpdatableRequestError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def rejected_last_month
        rejected_requests = @current_client.rejected_requests_last_month
        render(json: {service_requests: rejected_requests}, status: :ok)
    end
end
