class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.text :description
      t.references :provider
      t.timestamps
    end
  end
end
