class CreateServiceChangeRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :service_change_requests do |t|
      t.integer :status, default: 0
      t.references :service_request
      t.references :plan
      t.timestamps
    end
  end
end
