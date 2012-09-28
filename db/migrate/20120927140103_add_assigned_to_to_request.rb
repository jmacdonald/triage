class AddAssignedToToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :assigned_to_id, :integer
  end
end
