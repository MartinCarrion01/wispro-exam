class SubscriptionRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :client
    belongs_to :plan

    def self.create_subscription_request(plan_id, client)
        plan = Plan.find_by(id: plan_id)
        if plan.nil?
            raise ActiveRecord::RecordNotFound.new("El plan solicitado no existe")
        end
        if client.has_a_pending_request_to_given_provider?(plan.provider_id)
            raise PendingRequestToGivenProviderError
        end
        if client.has_an_active_plan_with_given_provider?(plan.provider_id)
            raise ActivePlanWithGivenProviderError
        end
        SubscriptionRequest.create!(plan: plan, client: client)
    end

    def self.update_status(subscription_request_id, new_status, provider)
        if new_status != "approved" && new_status != "rejected"
            raise InvalidStatusParametersError
        end
        subscription_request = SubscriptionRequest.find_by(id: subscription_request_id)
        if subscription_request.nil?
            raise ActiveRecord::RecordNotFound.new("La solicitud de contrato requerida no existe")
        end
        unless provider.can_update_subscription_request?(subscription_request)
            raise ProviderCantUpdateRequestError
        end
        if subscription_request.status != "pending"
            raise NotUpdatableRequestError
        end
        if new_status == "approved"
            Subscription.create!(client: subscription_request.client, plan: subscription_request.plan)
        end
        subscription_request.update!(status: new_status)
        subscription_request
    end

    class PendingRequestToGivenProviderError < StandardError
        def message
            "Usted ya posee otra solicitud de contratación pendiente de revision con este proveedor"
        end
    end

    class ActivePlanWithGivenProviderError < StandardError
        def message
            "Usted ya posee una suscripcion activa a un plan de este proveedor, si desea cambiar su plan, cree una solicitud de cambio de plan"
        end
    end

    class InvalidStatusParametersError < StandardError
        def message
            "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"
        end
    end

    class ProviderCantUpdateRequestError < StandardError
        def message
            "No puede revisar una solicitud de contratación de un plan que no le pertenece"
        end
    end

    class NotUpdatableRequestError < StandardError
        def message
            "La solicitud de contrato requerida ya ha sido revisada"
        end
    end
end
