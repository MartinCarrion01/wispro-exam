class CreateSubscriptionRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_requests do |t|
      t.integer :status
      t.references :client
      t.references :plan
      t.timestamps
    end
  end
end
