class ServiceChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :current_plan, class_name: 'ClientPlan', foreign_key: :client_plan_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id

    def self.create_service_change_request(current_plan_id, new_plan_id, client)
        client_plan = ClientPlan.find_by(plan_id: current_plan_id, client_id: client.id, active: true)
        if client_plan.nil?
            raise ActiveRecord::RecordNotFound.new("No posee una suscripcion activa al plan que desea cambiar")
        end
        if client.has_a_pending_change_request_to_given_provider(client_plan.plan.provider_id)?
            raise PendingChangeRequestToGivenProviderError
        end
        new_plan = Plan.find_by(id: new_plan_id)
        if new_plan.nil?
            raise ActiveRecord::RecordNotFound.new("No existe el plan al cual desea cambiarse")
        end
        unless client_plan.plan.does_belong_to_the_same_provider_as?(new_plan)
            raise NewPlanIsFromOtherProviderError
        end
        ServiceChangeRequest.create(current_plan: client_plan, new_plan: new_plan, client: client)
    end

    def self.update_status(service_change_request_id, new_status, provider)
        if new_status != "approved" && new_status != "rejected"
            raise InvalidStatusParametersError
        end
        service_change_request = ServiceChangeRequest.find_by(id: service_change_request_id)
        if service_change_request.nil? 
            raise ActiveRecord::RecordNotFound.new("La solicitud de cambio de plan requerida no existe")
        end
        unless provider.can_update_service_change_request?(service_change_request)
            raise ProviderCantUpdateChangeRequestError
        end
        if service_change_request.status != "pending"
            raise NotUpdatableChangeRequestError
        end
        if new_status == "approved"
            ClientPlan.create(client: service_change_request.current_plan.client, plan: service_change_request.new_plan)
            service_change_request.current_plan.active = false
        end
        service_change_request.status = new_status
        service_change_request.save
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
            "No puede revisar una solicitud de cambio de un plan que no le pertence al proveedor actual"
        end
    end

    class NotUpdatableChangeRequestError < StandardError
        def message
            "La solicitud de cambio de plan no es válida para su revisión"
        end
    end
end
