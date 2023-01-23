require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  test "subscription_created" do
    mail = SubscriptionMailer.subscription_created
    assert_equal "Subscription created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
