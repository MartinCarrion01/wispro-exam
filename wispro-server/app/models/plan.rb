class Plan < ApplicationRecord
    validates :description, presence: true

    has many :service_requests
    has_many :clients, through: :service_requests

    def self.index
        
    end
end
