class Api::V1::Admin::SubscriptionChangeRequestsController < Api::V1::Admin::BaseController    
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

    def provider
        @current_user.provider
    end
end
