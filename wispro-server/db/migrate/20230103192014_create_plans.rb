class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :description
      t.references :provider
      t.timestamps
    end
  end
end
