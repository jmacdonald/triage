class DefaultStatusBooleansToFalse < ActiveRecord::Migration
  def change
    change_column :statuses, :default, :boolean, :default => false
    change_column :statuses, :closed, :boolean, :default => false
  end
end
