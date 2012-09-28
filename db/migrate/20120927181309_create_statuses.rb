class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :title
      t.boolean :default
      t.boolean :closed

      t.timestamps
    end
  end
end
