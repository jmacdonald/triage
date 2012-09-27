class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :requests, :user_id
  end
end
