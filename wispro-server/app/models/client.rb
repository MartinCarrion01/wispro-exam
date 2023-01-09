class Client < ApplicationRecord
    has_secure_password

    validates :username, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :password, length: {in: 8..20}, if: -> { new_record? || password.present? }

    has_many :subscription_requests
    has_many :plans, through: :subscription_requests
    has_many :subscriptions
    has_many :plans, through: :subscriptions

    def has_a_pending_request_to_given_provider?(provider_id)
        Client.joins(subscription_requests: :plan)
        .where(subscription_requests: {client_id: self.id, status: "pending"},
             plan: {provider_id: provider_id}).exists?
    end

    def has_an_active_subscription_with_given_provider?(provider_id)
        Client.joins(subscriptions: :plan)
        .where(subscriptions: {active: true, client_id: self.id},
             plan: {provider_id: provider_id}).exists?
    end

    def has_a_pending_change_request_to_given_provider?(provider_id)
        SubscriptionChangeRequest.includes(:current_subscription => :plan)
        .where(status: "pending",
             current_subscription: {client_id: self.id, plans: {provider_id: provider_id}})
             .exists?
    end

    def rejected_requests_last_month
        SubscriptionRequest.where(client_id: self.id,
            status: "rejected",
            created_at: (Time.now - 1.month)..)
    end
end
