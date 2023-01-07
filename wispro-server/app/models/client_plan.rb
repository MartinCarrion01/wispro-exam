class ClientPlan < ApplicationRecord
    belongs_to :client
    belongs_to :plan

    def self.has_an_active_plan_with_given_provider?(client_id, provider_id)
        ClientPlan.includes("plan").where(client_id: client_id, plan: {provider_id: provider_id}).exists?
    end
end
