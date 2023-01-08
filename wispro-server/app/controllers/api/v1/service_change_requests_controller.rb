class Api::V1::ServiceChangeRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[create]
    before_action :authenticate_provider, only: %i[update_status]
    
    def create
        begin
            service_change_request = ServiceChangeRequest.create_service_change_request(params[:current_plan_id], params[:new_plan_id], @current_client)
            render(json: {service_change_request: service_change_request},status: :created)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid=> exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue ServiceChangeRequest::PendingChangeRequestToGivenProviderError,
             ServiceChangeRequest::NewPlanIsFromOtherProviderError => exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end

    def update_status
        begin
            service_change_request = ServiceChangeRequest.update_status(params[:id], params[:status], @current_provider)
            render(json: {service_change_request: service_change_request},status: :ok)
        rescue ActiveRecord::RecordNotFound => exception
            render(json: {message: exception.message}, status: :not_found)
        rescue ActiveRecord::RecordInvalid=> exception
            render(json: {message: exception.record.errors}, status: :bad_request)
        rescue ServiceChangeRequest::InvalidStatusParametersError,
             ServiceChangeRequest::ProviderCantUpdateChangeRequestError, 
             ServiceChangeRequest::NotUpdatableChangeRequestError=> exception
            render(json: {message: exception.message}, status: :bad_request)
        end
    end
end
