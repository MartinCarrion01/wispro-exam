class ServiceRequest < ApplicationRecord
    enum :status, %i[pending approved rejected inactive]

    belongs_to :client
    belongs_to :plan

    def self.rejected_last_month(client_id)
        rejected_requests = ServiceRequest.where(client_id: client_id,
            status: "rejected",
            created_at: (Time.now - 1.month)..)
        rejected_requests
    end
end
