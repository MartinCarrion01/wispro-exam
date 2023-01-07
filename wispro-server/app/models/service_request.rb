class ServiceRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :client
    belongs_to :plan

    def update_status(new_status)
        self.status = new_status
        if new_status == "approved"
            ClientPlan.create(client: self.client, plan: self.plan)
        end
        self.save
    end
end
