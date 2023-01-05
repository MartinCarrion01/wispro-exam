class Plan < ApplicationRecord
    validates :description, presence: true

    has_many :service_requests
    has_many :clients, through: :service_requests
end
