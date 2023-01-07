class CreateClientPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :client_plans do |t|
      t.boolean :active, default: true
      t.references :client
      t.references :plan
      t.timestamps
    end
  end
end
