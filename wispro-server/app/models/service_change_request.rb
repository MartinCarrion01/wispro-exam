class ServiceChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :current_plan, class_name: 'ClientPlan', foreign_key: :client_plan_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id

    def update_status(new_status)
        self.status = new_status
        if new_status == "approved"
            ClientPlan.create(client: self.current_plan.client, plan: self.new_plan)
            self.current_plan.active = false
        end
        self.save
    end
end
