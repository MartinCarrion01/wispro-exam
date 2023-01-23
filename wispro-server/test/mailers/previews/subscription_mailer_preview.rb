# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/subscription_created
  def subscription_created
    SubscriptionMailer.subscription_created
  end

end
