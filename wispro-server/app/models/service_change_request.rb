class ServiceChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :current_plan, class_name: 'ClientPlan', foreign_key: :client_plan_id 
    belongs_to :new_plan, class_name: 'Plan', foreign_key: :plan_id
end
