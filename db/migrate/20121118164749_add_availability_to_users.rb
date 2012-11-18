class AddAvailabilityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available, :boolean, default: true
  end
end
