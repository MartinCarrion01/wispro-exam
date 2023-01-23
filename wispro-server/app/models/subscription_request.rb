class SubscriptionRequest < ApplicationRecord
    enum :status, %i[pending approved rejected], default: :pending

    belongs_to :client
    belongs_to :plan
    
    before_update :check_if_subscription_request_has_been_updated

    validate :client_has_a_pending_request_to_given_provider?,
     :client_has_an_active_subscription_with_given_provider?, on: :create
    
    validate :are_status_parameters_correct?, on: :update

    after_update :queue_subscription_creation, if: :approved?

    class RequestAlreadyUpdatedError < StandardError; end

    def create_date
        self.created_at.strftime("%d/%m/%Y")
    end

    def client_has_a_pending_request_to_given_provider?
        if client.has_a_pending_request_to_given_provider?(plan.provider_id)
            errors.add(:base, "Usted ya posee otra solicitud de contratación pendiente de revision con este proveedor")
        end
    end

    def client_has_an_active_subscription_with_given_provider?
        if client.has_an_active_subscription_with_given_provider?(plan.provider_id)
            errors.add(:base, "Usted ya posee una suscripcion activa a un plan de este proveedor, si desea cambiar su plan, cree una solicitud de cambio de plan")
        end
    end

    def are_status_parameters_correct?
        if status != "approved" && status != "rejected"
            errors.add(:base, "Solo se puede cambiar la solicitud a los estados 'approved' y 'rejected'")
        end
    end

    def check_if_subscription_request_has_been_updated
        raise RequestAlreadyUpdatedError.new "La solicitud de contrato requerida ya ha sido revisada" unless status_was == "pending"
    end

    def queue_subscription_creation
        CreateSubscriptionJob.perform_in(10.seconds, id)
    end
end