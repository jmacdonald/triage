class RenameUserToAuthor < ActiveRecord::Migration
  def change
    rename_column :requests, :user_id, :author_id
  end
end
