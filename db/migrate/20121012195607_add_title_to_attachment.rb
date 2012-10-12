class AddTitleToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :title, :string
  end
end
