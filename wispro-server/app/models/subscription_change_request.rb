class SubscriptionChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :current_subscription, class_name: 'Subscription', autosave: true, foreign_key: :subscription_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id

    def self.create_subscription_change_request(current_subscription_id, new_plan_id, client)
        subscription = Subscription.find_by(plan_id: current_subscription_id, client_id: client.id, active: true)
        if subscription.nil?
            raise ActiveRecord::RecordNotFound.new("No posee una suscripcion activa al plan que desea cambiar")
        end
        if client.has_a_pending_change_request_to_given_provider?(subscription.plan.provider_id)
            raise PendingChangeRequestToGivenProviderError
        end
        new_plan = Plan.find_by(id: new_plan_id)
        if new_plan.nil?
            raise ActiveRecord::RecordNotFound.new("No existe el plan al cual desea cambiarse")
        end
        unless subscription.plan.does_belong_to_the_same_provider_as?(new_plan)
            raise NewPlanIsFromOtherProviderError
        end
        SubscriptionChangeRequest.create!(current_subscription: subscription, new_plan: new_plan)
    end

    def self.update_status(subscription_change_request_id, new_status, provider)
        if new_status != "approved" && new_status != "rejected"
            raise InvalidStatusParametersError
        end
        subscription_change_request = SubscriptionChangeRequest.find_by(id: subscription_change_request_id)
        if subscription_change_request.nil? 
            raise ActiveRecord::RecordNotFound.new("La solicitud de cambio de plan requerida no existe")
        end
        unless provider.can_update_subscription_change_request?(subscription_change_request)
            raise ProviderCantUpdateChangeRequestError
        end
        if subscription_change_request.status != "pending"
            raise NotUpdatableChangeRequestError
        end
        if new_status == "approved"
            Subscription.create!(client: subscription_change_request.current_subscription.client, plan: subscription_change_request.new_plan)
            subscription_change_request.current_subscription.active = false
        end
        subscription_change_request.status = new_status
        subscription_change_request.save!
        subscription_change_request
    end

    class PendingChangeRequestToGivenProviderError < StandardError
        def message
            "Usted ya posee una solicitud de cambio pendiente de revision con el proveedor requerido"
        end
    end

    class NewPlanIsFromOtherProviderError < StandardError
        def message
            "El plan al cual desea cambiarse no es del mismo proveedor de su plan actual"
        end
    end

    class InvalidStatusParametersError < StandardError
        def message
            "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"
        end
    end
    
    class ProviderCantUpdateChangeRequestError < StandardError
        def message
            "No puede revisar una solicitud de cambio de un plan que no le pertenece"
        end
    end

    class NotUpdatableChangeRequestError < StandardError
        def message
            "La solicitud de cambio de plan requerida ya ha sido revisada"
        end
    end
end
