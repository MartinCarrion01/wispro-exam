class Client < ApplicationRecord
    has_secure_password

    validates :username, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :password, length: {in: 8..20}, if: -> { new_record? || !password.nil? }

    has_many :service_requests
    has_many :plans, through: :service_requests
    has_many :client_plans
    has_many :plans, through: :client_plans

    def has_a_pending_request_to_given_provider?(provider_id)
        Client.includes(:service_requests, :plans).where(service_requests: {client_id: self.id, status: "pending", plans:{provider_id: provider_id}}).exists?
    end

    def has_an_active_plan_with_given_provider?(provider_id)
        Client.includes(:client_plans, :plans).where(client_plans: {active: true, client_id: self.id, plans: {provider_id: provider_id}}).exists?
    end

    def has_a_pending_change_request_to_given_provider?(provider_id)
        ServiceChangeRequest.includes(:current_plan => :plan).where(status: "pending", current_plan: {client_id: self.id, plans: {provider_id: provider_id}}).exists?
    end

    def rejected_requests_last_month
        ServiceRequest.where(client_id: self.id,
            status: "rejected",
            created_at: (Time.now - 1.month)..)
    end
end
