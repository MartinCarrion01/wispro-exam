class Api::V1::SubscriptionRequestsController < ApplicationController
    before_action :authenticate_client, only: %i[index create rejected_last_month]
    before_action :authenticate_provider, only: %i[update_status]

    def index
        subscription_requests = SubscriptionRequest.where(client_id: @current_client.id)

        formatted_subscription_requests = format_subscription_requests(subscription_requests)
        
        render(json: {subscription_requests: formatted_subscription_requests}, status: :ok)
    end

    def create
        created_subscription_request = SubscriptionRequest.create_subscription_request(params[:plan_id], @current_client)
        
        render(json: {subscription_request: created_subscription_request}, status: :created)
    end

    def update_status
        updated_subscription_request = SubscriptionRequest.update_status(params[:id], params[:status], @current_provider)
        
        render(json: {subscription_request: updated_subscription_request}, status: :ok)
    end

    def rejected_last_month
        rejected_requests = @current_client.rejected_requests_last_month
        
        formatted_rejected_requests = format_subscription_requests(rejected_requests)
        
        render(json: {subscription_requests: formatted_rejected_requests}, status: :ok)
    end

    private
    def format_subscription_requests(subscription_requests)
        subscription_requests.as_json(only: [:id, :status],
                                        methods: :create_date,
                                        include: {plan: 
                                                    {only: :description, 
                                                    include: {provider: {only: :name}}}})
    end
end