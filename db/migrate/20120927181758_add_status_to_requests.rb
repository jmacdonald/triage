class AddStatusToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :status_id, :integer
  end
end
