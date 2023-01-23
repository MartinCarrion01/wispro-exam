class ChangeSubscriptionJob
  include Sidekiq::Job

  def perform(subscription_change_request_id)
    subscription_change_request = SubscriptionChangeRequest.find(subscription_change_request_id)
    Subscription.create!(client: subscription_change_request.current_subscription.client, plan: subscription_change_request.new_plan)
    subscription_change_request.current_subscription.active = false
    subscription_change_request.save!
  end
end
