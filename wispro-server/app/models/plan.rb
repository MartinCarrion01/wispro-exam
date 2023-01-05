class Plan < ApplicationRecord
    validates :description, presence: true

    has_many :service_requests
    has_many :clients, through: :service_requests

    scope :filter_by_provider, ->(isp_id) {where(provider_id)}

    def self.index(isp_id=nil)

    end
end
