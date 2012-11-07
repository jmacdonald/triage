class CreateResponsibilities < ActiveRecord::Migration
  def change
    create_table :responsibilities do |t|
      t.integer :user_id
      t.integer :system_id

      t.timestamps
    end
  end
end
