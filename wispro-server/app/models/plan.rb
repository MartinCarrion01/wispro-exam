class Plan < ApplicationRecord
    validates :description, presence: true

    has_many :service_requests
    has_many :clients, through: :service_requests

    def does_belong_to_the_same_provider_as?(plan)
        self.provider_id == plan.provider_id
    end
end
