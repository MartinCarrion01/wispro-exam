class Api::V1::Admin::SubscriptionRequestsController < Api::V1::Admin::BaseController
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

    private
    def provider
        @current_user.provider
    end
end