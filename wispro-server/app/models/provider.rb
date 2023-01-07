class Provider < ApplicationRecord
    validates :name, presence: true

    has_many :plans, dependent: :delete_all

    def can_update_service_request?(service_request)
        self.id == service_request.plan.provider.id
    end

    def can_update_service_change_request?(service_change_request)
        self.id == service_change_request.new_plan.provider.id
    end
end
