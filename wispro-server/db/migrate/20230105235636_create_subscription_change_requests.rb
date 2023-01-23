class CreateSubscriptionChangeRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_change_requests do |t|
      t.integer :status
      t.references :subscription
      t.references :plan
      t.timestamps
    end
  end
end
