class Api::V1::SubscriptionRequestsController < ApplicationController
    before_action :authorize_client, only: %i[index create rejected_last_month]
    before_action :authorize_provider_admin, only: %i[update]

    def index
        subscription_requests = SubscriptionRequest.where(client_id: client.id)
        formatted_subscription_requests = format_subscription_requests(subscription_requests)
        render(json: {subscription_requests: formatted_subscription_requests}, status: :ok)
    end

    def create
        plan = Plan.find_by(id: params[:plan_id])
        if plan.nil?
            raise ActiveRecord::RecordNotFound.new("El plan solicitado no existe")
        end

        subscription_request = SubscriptionRequest.create!(plan: plan, client: client)
        render(json: {subscription_request: subscription_request}, status: :created)
    end

    def update
        subscription_request = SubscriptionRequest.find_by(id: params[:id])
        if subscription_request.nil?
            raise ActiveRecord::RecordNotFound.new("La solicitud de contrato requerida no existe")
        end

        unless provider.owns_the_plan_stated_in_this_subscription_request?(subscription_request)
            raise ProviderAccessForbiddenError.new "No puede revisar una solicitud de contratación de un plan que no le pertenece"
        end

        subscription_request.update!(status: params[:status])
        render(json: {subscription_request: subscription_request}, status: :ok)
    end

    def rejected_last_month
        rejected_requests = client.rejected_requests_last_month
        formatted_rejected_requests = format_subscription_requests(rejected_requests)
        render(json: {subscription_requests: formatted_rejected_requests}, status: :ok)
    end

    private
    class ProviderAccessForbiddenError < StandardError; end 

    def format_subscription_requests(subscription_requests)
        subscription_requests.as_json(only: [:id, :status],
                                        methods: :create_date,
                                        include: {plan: 
                                                    {only: :description, 
                                                    include: {provider: {only: :name}}}})
    end

    def client
        @current_user.client
    end

    def provider
        @current_user.provider
    end
end