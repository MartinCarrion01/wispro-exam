class SubscriptionChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :current_subscription, class_name: 'Subscription', autosave: true, foreign_key: :subscription_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id

    def self.create_subscription_change_request(current_plan_id, new_plan_id, client)
        subscription = Subscription.find_by(plan_id: current_plan_id, client_id: client.id, active: true)
        if subscription.nil?
            raise ActiveRecord::RecordNotFound.new("No posee una suscripcion activa al plan que desea cambiar")
        end

        if client.has_a_pending_change_request_to_given_provider?(subscription.plan.provider_id)
            raise ClientHasPendingChangeRequestToGivenProviderError
        end

        new_plan = Plan.find_by(id: new_plan_id)
        if new_plan.nil?
            raise ActiveRecord::RecordNotFound.new("No existe el plan al cual desea cambiarse")
        end

        unless subscription.plan.does_belong_to_the_same_provider_as?(new_plan)
            raise PlanInSubscriptionAndPlanInChangeRequestAreFromDifferentProvidersError
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

        unless provider.owns_the_plan_stated_in_this_subscription_change_request?(subscription_change_request)
            raise ProviderIsNotTheOwnerOfThePlanInChangeRequestError
        end

        if subscription_change_request.status != "pending"
            raise SubscriptionChangeRequestHasBeenUpdatedAlreadyError
        end

        if new_status == "approved"
            Subscription.create!(client: subscription_change_request.current_subscription.client, plan: subscription_change_request.new_plan)
            subscription_change_request.current_subscription.active = false
        end

        subscription_change_request.status = new_status
        subscription_change_request.save!
        subscription_change_request
    end

    # Definicion de errores de validacion que pueden surgir
    # a la hora de crear o actualizar solicitudes de cambio de plan: 
    class ClientHasPendingChangeRequestToGivenProviderError < StandardError
        def message
            "Usted ya posee una solicitud de cambio pendiente de revision con el proveedor requerido"
        end
    end

    class PlanInSubscriptionAndPlanInChangeRequestAreFromDifferentProvidersError < StandardError
        def message
            "El plan al cual desea cambiarse no es del mismo proveedor de su plan actual"
        end
    end

    class InvalidStatusParametersError < StandardError
        def message
            "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'"
        end
    end
    
    class ProviderIsNotTheOwnerOfThePlanInChangeRequestError < StandardError
        def message
            "No puede revisar una solicitud de cambio de un plan que no le pertenece"
        end
    end

    class SubscriptionChangeRequestHasBeenUpdatedAlreadyError < StandardError
        def message
            "La solicitud de cambio de plan requerida ya ha sido revisada"
        end
    end
end
