class RenameAuthorToRequester < ActiveRecord::Migration
  def change
    rename_column :requests, :author_id, :requester_id
  end
end
