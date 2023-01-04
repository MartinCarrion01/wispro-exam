class CreateServiceRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :service_requests do |t|
      t.integer :status, default: 0
      t.references :client
      t.references :plan
      t.timestamps
    end
  end
end
