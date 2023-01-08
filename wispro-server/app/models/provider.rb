class Provider < ApplicationRecord
    validates :name, presence: true

    has_many :plans, dependent: :delete_all

    def can_update_subscription_request?(subscription_request)
        self.id == subscription_request.plan.provider_id
    end

    def can_update_subscription_change_request?(subscription_change_request)
        self.id == subscription_change_request.new_plan.provider_id
    end
end
