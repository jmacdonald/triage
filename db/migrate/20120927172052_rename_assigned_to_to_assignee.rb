class RenameAssignedToToAssignee < ActiveRecord::Migration
  def change
    rename_column :requests, :assigned_to_id, :assignee_id
  end
end
