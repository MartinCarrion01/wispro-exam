class CreateSubscriptionJob
  include Sidekiq::Job

  def perform(subscription_request_id)
    subscription_request = SubscriptionRequest.find(subscription_request_id)
    Subscription.create(plan: subscription_request.plan, client: subscription_request.client)
  end
end
