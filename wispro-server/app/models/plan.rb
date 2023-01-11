class Plan < ApplicationRecord
    validates :description, presence: true

    belongs_to :provider
    
    has_many :subscription_requests
    has_many :clients, through: :subscription_requests

    def does_belong_to_the_same_provider_as?(plan)
        self.provider_id == plan.provider_id
    end
end
