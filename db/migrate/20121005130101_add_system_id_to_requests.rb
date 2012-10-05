class AddSystemIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :system_id, :integer
  end
end
