class Provider < ApplicationRecord
    validates :name, presence: true

    has_many :plans, dependent: :delete_all
    
    has_many :users

    def owns_the_plan_stated_in_this_subscription_request?(subscription_request)
        self.id == subscription_request.plan.provider_id
    end

    def owns_the_plan_stated_in_this_subscription_change_request?(subscription_change_request)
        self.id == subscription_change_request.new_plan.provider_id
    end
end
