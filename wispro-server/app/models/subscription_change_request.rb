class SubscriptionChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected], default: :pending

    belongs_to :current_subscription, class_name: 'Subscription', autosave: true, foreign_key: :subscription_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id

    before_update :check_if_subscription_change_request_has_been_updated

    validate :client_has_a_pending_change_request_to_given_provider?,
     :new_plan_belongs_to_same_provider_as_current_subscriptions_plan?, on: :create

    validate :are_status_parameters_correct?, on: :update

    after_update :queue_subscription_change, if: :approved?

    class ChangeRequestAlreadyUpdatedError < StandardError; end

    def client_has_a_pending_change_request_to_given_provider?
        if client.has_a_pending_change_request_to_given_provider?(plan.provider_id)
            errors.add(:base, "Usted ya posee una solicitud de cambio pendiente de revision con el proveedor requerido")
        end
    end

    def new_plan_belongs_to_same_provider_as_current_subscriptions_plan?
        unless current_subscription.plan.does_belong_to_the_same_provider_as?(new_plan)
            errors.add(:base, "El plan al cual desea cambiarse no es del mismo proveedor de su plan actual")
        end
    end

    def are_status_parameters_correct?
        if status != "approved" && status != "rejected"
            errors.add(:base, "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'")
        end
    end

    def check_if_subscription_change_request_has_been_updated
        if status_was != "pending"
            raise ChangeRequestAlreadyUpdatedError.new "La solicitud de cambio de plan requerida ya ha sido revisada"
        end
    end

    def queue_subscription_change
        ChangeSubscriptionJob.perform_in(10.seconds, id)
    end
end
