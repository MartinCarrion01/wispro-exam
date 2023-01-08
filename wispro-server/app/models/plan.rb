class Plan < ApplicationRecord
    validates :description, presence: true

    has_many :service_requests
    has_many :clients, through: :service_requests

    def does_belong_to_the_same_provider_as?(plan)
        self.provider_id == plan.provider_id
    end

    def self.index(provider_id=nil)
        if provider_id.present?
            provider = Provider.find_by(id: provider_id)
            if provider.nil?
                raise ActiveRecord::RecordNotFound.new("El proveedor solicitado no existe")
            end
            provider.plans
        else
            Plans.all
        end
    end
end
