class SubscriptionMailer < ApplicationMailer
  def subscription_created
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
