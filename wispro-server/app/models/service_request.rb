class ServiceRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :client
    belongs_to :plan

    def self.rejected_last_month(client_id)
        rejected_requests = ServiceRequest.where(client_id: client_id,
            status: "rejected",
            created_at: (Time.now - 1.month)..)
        rejected_requests
    end

    def update_status(new_status)
        self.status = new_status
        if new_status == "approved"
            ClientPlan.create(client: self.client, plan: self.plan)
        end
        self.save
    end
end
