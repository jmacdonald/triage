class RenameRequestsToTickets < ActiveRecord::Migration
  def change
    rename_table :requests, :tickets
  end
end
